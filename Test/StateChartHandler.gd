extends Node

const FORGING_OPTIONS = preload("res://Components/UI/forging_options.tscn")

@onready var state_chart : StateChart = $"../StateChart"
@onready var camera : Camera3D = $"../Camera3D"
@onready var forge : = get_parent()

var current_item : Interactable

func _on_item_node_click(sender: Interactable, event: InputEventMouseButton) -> void:
	if sender is ItemNode:
		var item_node = sender as ItemNode
		if event.button_index == MOUSE_BUTTON_LEFT:
			print(event)
			if event.is_pressed():
				state_chart.send_event("grabbed")
				current_item = item_node
			elif event.is_released():
				state_chart.send_event("released")
				
				if current_item.parent != null:
					# or parent.some_method() to do it and smth else
					current_item.position = Vector3.ZERO
				
				current_item = null
		elif (event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed() 
		and item_node.parent is Anvil and item_node.item.item_type == Item.Types.Resource
		and forge.near_anvil):
			var forging_options = FORGING_OPTIONS.instantiate()
			#forging_options.position = event.position
			forging_options.item = item_node.item
			add_child(forging_options)
			forging_options.chosen.connect(func(new_item : Item):
				pass # TODO
				)
			pass # create form with 
	pass # Replace with function body.


func _on_dragging_state_processing(_delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 2
	current_item.global_position = camera.project_ray_origin(mouse_pos) + camera.project_ray_normal(mouse_pos) * ray_length
	pass # Replace with function body.

func get_active_state():
	return (state_chart._state as CompoundState)._active_state.name

func _on_station_click(station: CraftingStation, event: InputEventMouseButton) -> void:
	if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT and get_active_state() == "Dragging":
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
	elif event.button_index == MOUSE_BUTTON_RIGHT and get_active_state() == "Dragging":
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
