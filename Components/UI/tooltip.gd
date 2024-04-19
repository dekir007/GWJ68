extends CanvasLayer

const CRAFTING_OPTION = preload("res://Components/UI/crafting_option.tscn")


@export var item_node : ItemNode

@onready var close_button: TextureButton = $CloseButton
@onready var header: Label = %Header
@onready var description: Label = %Description
@onready var temperature: Label = %Temperature

@onready var hover_color = close_button.modulate.darkened(.2)
@onready var normal_color = close_button.modulate 

func _ready() -> void:
	if item_node == null:
		return
	var item = item_node.item
	header.text = item.item_name if !item.item_name.is_empty() else "Empty name"
	description.text = "Quality: " + item.Quality.find_key(item.quality) + (("\nDescription: " + item.description) if !item.description.is_empty() else "")
	temperature.text = "Temperature: " + str(round(item_node.temperature)) + " degrees(%s)" % [item_node.get_state_for_forging()]

func _process(delta: float) -> void:
	temperature.text = "Temperature: " + str(round(item_node.temperature)) + " degrees(%s)" % [item_node.get_state_for_forging()]

func _on_close_button_mouse_entered() -> void:
	close_button.modulate = hover_color
	pass # Replace with function body.


func _on_close_button_mouse_exited() -> void:
	close_button.modulate = normal_color
	pass # Replace with function body.


func _on_close_button_pressed() -> void:
	queue_free()
	pass # Replace with function body.
