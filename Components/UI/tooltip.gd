extends CanvasLayer

const CRAFTING_OPTION = preload("res://Components/UI/crafting_option.tscn")

signal put_away(item_node : ItemNode)

@export var item_node : ItemNode

@onready var close_button: TextureButton = $CloseButton
@onready var header: Label = %Header
@onready var description: Label = %Description
@onready var temperature: Label = %Temperature
@onready var put_away_btn: TextureButton = $PutAwayBtn

@onready var hover_color = close_button.modulate.darkened(.2)
@onready var normal_color = close_button.modulate 

func _ready() -> void:
	if item_node == null:
		return
	var item = item_node.item
	header.text = item.item_name if !item.item_name.is_empty() else "Empty name"
	description.text = "Quality: " + item.quality_str + (("\nDescription: " + item.description) if !item.description.is_empty() else "")
	temperature.text = "Temperature: " + str(round(item_node.temperature)) + " degrees(%s)" % [item_node.get_state_for_forging()]
	if item.item_type_str != "Equipment":
		put_away_btn.disabled = true
		put_away_btn.tooltip_text = "Not a part of equipment"
		

func _process(delta: float) -> void:
	if item_node == null:
		return
	var state = item_node.get_state_for_forging()
	temperature.text = "Temperature: " + str(round(item_node.temperature)) + " degrees(%s)" % [state]
	if item_node.item.item_type_str == "Equipment":
		if item_node.temperature > 50:
			put_away_btn.disabled = true
			put_away_btn.tooltip_text = "Too hot!"
		else:
			put_away_btn.disabled = false
			put_away_btn.tooltip_text = ""

func _on_close_button_mouse_entered() -> void:
	close_button.modulate = hover_color
	pass # Replace with function body.


func _on_close_button_mouse_exited() -> void:
	close_button.modulate = normal_color
	pass # Replace with function body.


func _on_close_button_pressed() -> void:
	queue_free()
	pass # Replace with function body.


func _on_put_away_btn_pressed() -> void:
	# add item node to table
	put_away.emit(item_node)
	queue_free()
	pass # Replace with function body.
