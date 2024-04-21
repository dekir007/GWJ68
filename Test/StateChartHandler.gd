extends Node

## needs rework with raycast

const RAY_LENGTH = 100

const FORGING_OPTIONS = preload("res://Components/UI/forging_options.tscn")
const TOOLTIP = preload("res://Components/UI/tooltip.tscn")

@onready var state_chart : StateChart = $"../StateChart"
@onready var camera : Camera3D = $"../Camera3D"
@onready var forge : = get_parent()
@onready var anvil: Anvil = %Anvil
@onready var table: Node3D = $"../Forge/Table"

var current_item : ItemNode
var new_item : Item

var clicked : int = 0
var tw : Tween

func ray_cast(collision_mask = 2**7, exclude = []) -> Dictionary:
	var space_state = forge.get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end, collision_mask, exclude)
	#query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	return result

func _on_dragging_state_processing(_delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 2
	current_item.global_position = camera.project_ray_origin(mouse_pos) + camera.project_ray_normal(mouse_pos) * ray_length
	pass # Replace with function body.

func get_active_state():
	return (state_chart._state as CompoundState)._active_state.name


func _on_hammer_hit_state_entered() -> void:
	print("_on_hammer_hit_state_entered")
	clicked += 1
	if clicked == 3:
		print("3")
		state_chart.send_event("forged")
	
		pass # done

## after particles state
func _on_transition_taken() -> void:
	anvil.current_item.set_item(new_item)
	new_item = null

func _on_forging_compound_state_entered() -> void:
	clicked = 0
	pass # Replace with function body.

#region idle

func _on_idle_state_entered() -> void:
	print("idle")
	
func _on_idle_state_unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F and !forge.near_anvil and (tw == null or !tw.is_running()):
			# yes, this code should be refactored
			tw = get_tree().create_tween()
			var final_val #= camera_3d.rotation_degrees.y 
			var c : Callable
			final_val = 140
			state_chart.send_event("start_distribution")
			c = Callable(func():
					forge.equipment_distribution.show()
					)
			tw.tween_property(camera, "rotation_degrees:y", final_val, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tw.tween_callback(c)
			
	if Input.is_action_just_pressed("get_near_anvil"):
		if !forge.near_anvil:
			forge.animation_player.play("to_anvil")
			forge.near_anvil = true
		else:
			forge.animation_player.play_backwards("to_anvil")
			forge.near_anvil = false
	
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		print(event)
		var res = ray_cast()
		if res.is_empty():
			return
		var node = res["collider"].get_parent()
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed(): #release logic in dragged
				if node is ItemNode:
					state_chart.send_event("grabbed")
					current_item = node
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				var item_node = res["collider"].get_parent()
				if !(item_node is ItemNode):
					return
				if item_node.parent is Anvil and forge.near_anvil:
					var forging_options = FORGING_OPTIONS.instantiate()
					#forging_options.position = event.position
					forging_options.item_node = item_node
					add_child(forging_options)
					forging_options.chosen.connect(func(_new_item : Item):
						pass # TODO
						state_chart.send_event("start_forging")
						new_item = _new_item
						# start forging (clicking) 
						)
				else:
					var tooltip = TOOLTIP.instantiate()
					tooltip.item_node = item_node
					tooltip.put_away.connect(func(_item_node):
						forge.items_on_table.append(_item_node)
						table.put_item(_item_node)
						)
					add_child(tooltip)
					pass # tooltip
	pass # Replace with function body.

#region dragging

func _on_dragging_state_entered() -> void:
	print("dragging")

func _on_dragging_state_unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		print(event)
		#if res.is_empty(): # no station
			#return
		#var node = res["collider"].get_parent()
		if event.button_index == MOUSE_BUTTON_LEFT:
			var res = ray_cast(2**7, [current_item.rid])
			if event.is_released():
				if res.is_empty(): # no station
					state_chart.send_event("released")
					if current_item != null and current_item.parent != null:
						# or parent.some_method() to do it and smth else
						current_item.position = Vector3.ZERO
					
					current_item = null
				else:
					var station = res["collider"].get_parent()
					state_chart.send_event("released")
					if !(station is CraftingStation):
						current_item.position = Vector3.ZERO
						return
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
					elif current_item.parent != null: # swap
						var sw = station.current_item
						var station2 = current_item.parent
						current_item.parent.take_item()
						station.take_item()
						station.get_item(current_item)
						station2.get_item(sw)
						#current_item.position = Vector3.ZERO
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_released():
				state_chart.send_event("released")
				current_item.position = Vector3.ZERO
	pass # Replace with function body.

#endregion

#region wait_hit

func _on_waiting_hit_state_entered() -> void:
	print("_on_waiting_hit_state_entered")

func _on_wait_hit_state_unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		print(event)
		var res = ray_cast()
		if res.is_empty():
			return
		var node = res["collider"].get_parent()
		if node is ItemNode:
			state_chart.send_event("hammer_hit")
	pass # Replace with function body.

#endregion


func _on_distribution_state_entered() -> void:
	forge.get_ingots_layer.hide()
	forge.equipment_distribution.get_items(forge.items_on_table.map(func(x): return x.item))
	pass # Replace with function body.

func _on_distribution_state_exited() -> void:
	forge.get_ingots_layer.show()
	pass

func _on_distribution_state_unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F and !forge.near_anvil and (tw == null or !tw.is_running()):
			# yes, this code should be refactored
			tw = get_tree().create_tween()
			var final_val #= camera_3d.rotation_degrees.y 
			var c : Callable
			final_val = -43
			state_chart.send_event("end_distribution")
			tw.set_parallel(true)
			c = Callable(func():
					forge.equipment_distribution.hide()
					)
			tw.tween_property(camera, "rotation_degrees:y", final_val, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tw.tween_callback(c)
	pass # Replace with function body.

