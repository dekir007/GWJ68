extends Interactable
class_name ItemNode

@export var item : Item
@export var temperature : float = 20

var parent : CraftingStation

var mesh : MeshInstance3D
var outline : MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item.model != null:
		create_meshes()
		
		outline.hide()
		mouse_entered.connect(func():
			outline.show()
			)
		mouse_exited.connect(func():
			outline.hide()
			)
	pass # Replace with function body.

func set_item(val : Item):
	item = val
	mesh.queue_free()
	outline.queue_free()
	$Detection.get_child(0).call_deferred(&"call_deferred", &"queue_free")
	call_deferred(&"create_meshes")

func create_meshes():
	mesh = item.model.instantiate()
	add_child(mesh)
	
	mesh.create_convex_collision()
	mesh.get_child(0).get_child(0).reparent($Detection)
	mesh.get_child(0).queue_free()
	
	outline = MeshInstance3D.new() 
	outline.mesh = mesh.mesh.create_outline(0.03)
	outline.material_override = load("res://Assets/materials/outline_material.tres")
	outline.rotation = mesh.rotation
	add_child(outline)

func get_state_for_forging():
	if temperature < 1100:
		return "Needs to be hotter"
	elif temperature < 1500:
		return "Can forge"
	else:
		return "Too hot (worse quality)"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
