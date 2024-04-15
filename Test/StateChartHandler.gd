extends Node

@onready var state_chart: StateChart = $"../StateChart"
@onready var camera: Camera3D = $"../Camera3D"

var current_item : Interactable

func _on_item_node_click(sender: Interactable, event: InputEventMouseButton) -> void:
	if sender is ItemNode:
		print(event)
		if event.is_pressed():
			state_chart.send_event("grabbed")
			current_item = sender
		elif event.is_released():
			state_chart.send_event("released")
			
			if current_item.parent != null:
				# or parent.some_method() to do it and smth else
				current_item.position = Vector3.ZERO
			
			current_item = null
	pass # Replace with function body.


func _on_dragging_state_processing(_delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 2
	current_item.global_position = camera.project_ray_origin(mouse_pos) + camera.project_ray_normal(mouse_pos) * ray_length
	pass # Replace with function body.


func _on_station_click(station: CraftingStation, event: InputEventMouseButton) -> void:
	if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT and (state_chart._state as CompoundState)._active_state.name == "Dragging":
		state_chart.send_event("released")
		if station.current_item == null:
			if current_item.parent != null:
				# remove from old station
				current_item.parent.take_item()
			else:
				var p = current_item.get_parent()
				p.remove_child(current_item)
			station.get_item(current_item)
		elif station.current_item == current_item:
			current_item.position = Vector3.ZERO
		else:
			current_item.position = Vector3.ZERO
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		# cancel
		state_chart.send_event("released")
		current_item.position = Vector3.ZERO
	pass # Replace with function body.


func _on_idle_state_entered() -> void:
	print("idle")
	pass # Replace with function body.


func _on_dragging_state_entered() -> void:
	print("dragging")
	pass # Replace with function body.
