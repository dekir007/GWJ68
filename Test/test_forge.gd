extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var equipment_distribution: CanvasLayer = $EquipmentDistribution
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var near_anvil : = false
var tw : Tween

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F and !near_anvil and (tw == null or !tw.is_running()):
			# yes, this code should be refactored
			tw = get_tree().create_tween()
			var final_val #= camera_3d.rotation_degrees.y 
			var c : Callable
			if camera.rotation_degrees.y < 0:
				final_val = 140
				c = Callable(func():
						equipment_distribution.show()
						)
			else:
				final_val = -43
				tw.set_parallel(true)
				c = Callable(func():
						equipment_distribution.hide()
						)
				#equipment_distribution.hide()
			tw.tween_property(camera, "rotation_degrees:y", final_val, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tw.tween_callback(c)
			#camera_3d.rotate_y(PI/2)
		elif event.keycode == KEY_E:
			if !near_anvil:
				animation_player.play("to_anvil")
				near_anvil = true
			else:
				animation_player.play_backwards("to_anvil")
				near_anvil = false

