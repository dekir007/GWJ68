extends Node
@onready var state_chart: StateChart = $StateChart
@onready var overlay_panel: Panel = $OverlayPanel
@onready var overlay_text: Label = $OverlayPanel/OverlayText
@onready var customer_UI: PanelContainer = $"Customer UI"
@onready var customer_badge: TextureRect = $"Customer UI/HBoxContainer/TextureRect"
@onready var customer_text: Label = $"Customer UI/HBoxContainer/Label"
@onready var debug_panel: PanelContainer = $DebugPanel
@onready var serve_customer_button: Button = $DebugPanel/VBoxContainer/ServeCustomerButton
@onready var refuse_customer_button: Button = $DebugPanel/VBoxContainer/RefuseCustomerButton
@onready var quality_button: OptionButton = $DebugPanel/VBoxContainer/QualityButton
@onready var type_button: OptionButton = $DebugPanel/VBoxContainer/TypeButton

var evil_ap := 0
var rebel_ap := 0
var suspicion := 0:
	set(value):
		suspicion = maxi(0, value)
var day_number := 1

@export var debug_panel_visible := true:
	set(value):
		debug_panel.visible = value
		debug_panel_visible = value 

@export_group("Suspicion Amounts", "sus_amount_")
@export var sus_amount_agent := 33
@export var sus_amount_ignored := 10
@export_subgroup("Quality", "sus_amount_q_")
@export var sus_amount_q_unusable := 15
@export var sus_amount_q_shoddy := 3
@export var sus_amount_q_poor := 1
@export var sus_amount_q_ok := -5
@export var sus_amount_q_good := -10
@export var sus_amount_q_great := -25
@export var sus_amount_q_perfect := -50
@export var sus_amount_day_reduction := 10

@export_group("Army Power", "ap_amount_")
@export var ap_amount_unusable := 0
@export var ap_amount_shoddy := 1
@export var ap_amount_poor := 3
@export var ap_amount_ok := 5
@export var ap_amount_good := 10
@export var ap_amount_great := 25
@export var ap_amount_perfect := 50

@export var rebel_ap_multiplier := 3
@export var suspicion_limit := 100

@export var scenario_manager: ScenarioManager

func _ready():
	debug_panel.visible = debug_panel_visible

func serve_customer(equipment: Equipment):
	var customer = scenario_manager.current_customer
	if customer == null:
		return
	
	if customer.wanted_equipment != equipment.type:
		customer_text.text = "This isn't what I asked for.\n%s" % customer.request_text
		return
	match customer.type:
		Customer.Type.SOLDIER:
			evil_ap += get_army_power(equipment.quality)
			suspicion += get_suspicion(equipment.quality)
		Customer.Type.REBEL:
			rebel_ap += get_army_power(equipment.quality) * rebel_ap_multiplier
		Customer.Type.AGENT:
			suspicion += sus_amount_agent
	
	#customer_text.text = get_quality_response(equipment.quality)
	if scenario_manager.get_remaining_customers() > 0:
		scenario_manager.next_customer()
		display_customer()
	else:
		state_chart.send_event("day_end")

func refuse_customer():
	var customer = scenario_manager.current_customer
	if customer == null:
		return
	
	match customer.type:
		Customer.Type.SOLDIER:
			suspicion += sus_amount_ignored
		Customer.Type.AGENT:
			suspicion -= sus_amount_ignored
	
	if scenario_manager.get_remaining_customers() > 0:
		scenario_manager.next_customer()
		display_customer()
	else:
		state_chart.send_event("day_end")

func display_customer():
	var customer = scenario_manager.get_current_customer()
	customer_UI.show()
	customer_badge.texture = customer.badge
	customer_text.text = customer.request_text

func _on_setup_state_entered():
	state_chart.send_event("day_start")


func _on_day_start_state_entered():
	scenario_manager.setup_day(day_number)
	overlay_panel.show()
	var days_remaining := scenario_manager.get_remaining_days(day_number) + 1
	if days_remaining != 1:
		overlay_text.text = "Day %d\n%d days remaining until battle" % [day_number, days_remaining]
	else:
		overlay_text.text = "Day %d\n%d day remaining until battle" % [day_number, days_remaining]

func get_suspicion(quality: Equipment.Quality) -> int:
	match quality:
		Equipment.Quality.UNUSABLE:
			return sus_amount_q_unusable
		Equipment.Quality.SHODDY:
			return sus_amount_q_shoddy
		Equipment.Quality.POOR:
			return sus_amount_q_poor
		Equipment.Quality.OK:
			return sus_amount_q_ok
		Equipment.Quality.GOOD:
			return sus_amount_q_good
		Equipment.Quality.GREAT:
			return sus_amount_q_great
		Equipment.Quality.PERFECT:
			return sus_amount_q_perfect
		_:
			return 0
			
func get_quality_response(quality: Equipment.Quality) -> String:
	match quality:
		Equipment.Quality.UNUSABLE:
			return "This is unusable garbage"
		Equipment.Quality.SHODDY:
			return "This is shoddy quality"
		Equipment.Quality.POOR:
			return "This is poor"
		Equipment.Quality.OK:
			return "This is decent"
		Equipment.Quality.GOOD:
			return "This is good"
		Equipment.Quality.GREAT:
			return "This is great"
		Equipment.Quality.PERFECT:
			return "This is perfect"
		_:
			return "This is something"

func get_army_power(quality: Equipment.Quality) -> int:
	match quality:
		Equipment.Quality.UNUSABLE:
			return ap_amount_unusable
		Equipment.Quality.SHODDY:
			return ap_amount_shoddy
		Equipment.Quality.POOR:
			return ap_amount_poor
		Equipment.Quality.OK:
			return ap_amount_ok
		Equipment.Quality.GOOD:
			return ap_amount_good
		Equipment.Quality.GREAT:
			return ap_amount_great
		Equipment.Quality.PERFECT:
			return ap_amount_perfect
		_:
			return 0

func _on_day_start_state_exited():
	overlay_panel.hide()
	customer_UI.hide()

func _on_forge_start_state_entered():
	pass # Replace with function body.

func _on_forge_time_state_entered():
	pass # Replace with function body.

func _on_service_start_state_entered():
	pass # Replace with function body.

func _on_service_time_state_entered():
	scenario_manager.next_customer()
	display_customer()


func _on_day_end_state_entered():
	if suspicion >= suspicion_limit:
		state_chart.send_event("game_lost_suspicion")
		return
	
	suspicion -= sus_amount_day_reduction
	if scenario_manager.is_last_day(day_number):
		if rebel_ap >= evil_ap:
			state_chart.send_event("game_win")
			return
		else:
			state_chart.send_event("game_lost_army")
			return
	
	day_number += 1
	state_chart.send_event("setup")
	overlay_panel.show()
	overlay_text.text = "End of day"


func _on_end_forging_button_pressed():
	state_chart.send_event("service_start")


func _on_refuse_customer_button_pressed():
	refuse_customer()


func _on_serve_customer_button_pressed():
	var equip = Equipment.new(quality_from_int(quality_button.selected), type_from_int(type_button.selected))
	serve_customer(equip)

func quality_from_int(value: int) -> Equipment.Quality:
	match value:
		0:
			return Equipment.Quality.NONE
		1:
			return Equipment.Quality.UNUSABLE
		2:
			return Equipment.Quality.SHODDY
		3:
			return Equipment.Quality.POOR
		4:
			return Equipment.Quality.OK
		5:
			return Equipment.Quality.GOOD
		6:
			return Equipment.Quality.GREAT
		7:
			return Equipment.Quality.PERFECT
		_:
			return Equipment.Quality.NONE
			
func type_from_int(value: int) -> Equipment.Type:
	match value:
		0:
			return Equipment.Type.SWORD
		_:
			return Equipment.Type.SWORD


func _on_day_end_state_exited():
	overlay_panel.hide()


func _on_game_win_state_entered():
	overlay_panel.show()
	overlay_text.text = "You Win!\nThe rebels managed to beat the king and rescue you"


func _on_game_lost_suspicion_state_entered():
	overlay_panel.show()
	overlay_text.text = "You Lost!\nYou were executed for refusing to follow orders"


func _on_game_lost_army_state_entered():
	overlay_panel.show()
	overlay_text.text = "You Lost!\nThe rebels failed to defeat the king and you have been promoted to head blacksmith"


func _on_service_time_state_exited():
	customer_UI.hide()
