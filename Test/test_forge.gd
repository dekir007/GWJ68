extends Node3D

@onready var camera_3d: Camera3D = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_F:
		var tw = get_tree().create_tween()
		var final_val #= camera_3d.rotation_degrees.y 
		if camera_3d.rotation_degrees.y < 0:
			final_val = 140
		else:
			final_val = -50
		tw.tween_property(camera_3d, "rotation_degrees:y", final_val, .5)
		#camera_3d.rotate_y(PI/2)
