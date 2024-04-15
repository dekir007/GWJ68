extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ray(camera, layer, things = []):
	var ray_length = 10000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	#print(($DetectModule as Area3D).collision_layer)
	var query = PhysicsRayQueryParameters3D.create(from, to, layer, things)
	var res = space_state.intersect_ray(query)
	print(res)
	

func _on_static_body_3d_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	print("anvil ",event)
	ray(camera, $Detection.collision_layer)


func _on_area_3d_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	print("small ", event)
	ray(camera, $Detection.collision_layer)
