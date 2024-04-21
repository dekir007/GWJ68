extends Node

signal level_won
signal level_lose_sus
signal level_lose_army

@onready var state_chart: StateChart = $StateChart
@onready var overlay_panel: Panel = $CanvasLayer/OverlayPanel
@onready var overlay_text: Label = $CanvasLayer/OverlayPanel/OverlayText
@onready var customer_UI: PanelContainer = $CanvasLayer/"Customer UI"
@onready var customer_badge: TextureRect = $CanvasLayer/"Customer UI/HBoxContainer/TextureRect"
@onready var customer_text: Label = $CanvasLayer/"Customer UI/HBoxContainer/Label"
@onready var debug_panel: PanelContainer = $CanvasLayer/DebugPanel
@onready var serve_customer_button: Button = $CanvasLayer/DebugPanel/VBoxContainer/ServeCustomerButton
@onready var refuse_customer_button: Button = $CanvasLayer/DebugPanel/VBoxContainer/RefuseCustomerButton
@onready var quality_button: OptionButton = $CanvasLayer/DebugPanel/VBoxContainer/QualityButton

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
@export var sus_amount_agent := 34
@export var sus_amount_ignored := 10
#@export_subgroup("Quality", "sus_amount_q_")
#@export var sus_amount_q_bad := 15
#@export var sus_amount_q_shoddy := 3
#@export var sus_amount_q_poor := 1

@export_group("Army Power", "ap_amount_")
@export var ap_amount_bad := 5
@export var ap_amount_good := 20
@export var ap_amount_perfect := 50

@export var rebel_ap_multiplier := 1
@export var suspicion_limit := 100

@export var scenario_manager: ScenarioManager

func _ready():
	debug_panel.visible = debug_panel_visible

func serve_customer(equipment: Item):
	var customer = scenario_manager.current_customer
	if customer == null:
		return
	
	match customer.type:
		Customer.Type.SOLDIER:
			evil_ap += get_army_power(equipment.quality)
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
	customer_text.text = "Give me my equipment"

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


func get_army_power(quality: Item.Quality) -> int:
	match quality:
		Item.Quality.Bad:
			return ap_amount_bad
		Item.Quality.Good:
			return ap_amount_good
		Item.Quality.Perfect:
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
	var equip = Item.new()
	equip.item_type = Item.Types.Equipment
	equip.quality = quality_from_int(quality_button.selected)
	serve_customer(equip)

func quality_from_int(value: int) -> Item.Quality:
	match value:
		0:
			return Item.Quality.Bad
		1:
			return Item.Quality.Good
		2:
			return Item.Quality.Perfect
		_:
			return Item.Quality.Bad


func _on_day_end_state_exited():
	overlay_panel.hide()


func _on_game_win_state_entered():
	level_won.emit()


func _on_game_lost_suspicion_state_entered():
	level_lose_sus.emit()


func _on_game_lost_army_state_entered():
	level_lose_army.emit()

func _on_service_time_state_exited():
	customer_UI.hide()
