extends Node

@onready var state_chart: StateChart = $"../StateChart"
@onready var camera: Camera3D = $"../Camera3D"

var current_item : Interactable

func _on_item_node_click(sender: Interactable, event: InputEvent) -> void:
	if sender is ItemNode:
		print(event)
		if event.is_pressed():
			state_chart.send_event("grabbed")
			current_item = sender
		elif event.is_released():
			state_chart.send_event("released")
			current_item = null
	pass # Replace with function body.


func _on_dragging_state_processing(_delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 2
	current_item.global_position = camera.project_ray_origin(mouse_pos) + camera.project_ray_normal(mouse_pos) * ray_length
	pass # Replace with function body.


func _on_anvil_click(anvil: Anvil, event: InputEvent) -> void:
	if (state_chart._state as CompoundState)._active_state.name == "Dragging" and event.is_released():
		if anvil.current_item == null:
			state_chart.send_event("released")
			var p = current_item.get_parent()
			p.remove_child(current_item)
			anvil.get_item(current_item)
	pass # Replace with function body.
