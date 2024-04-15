extends Interactable
class_name ItemNode

@export var item : Item

var parent : CraftingStation

var mesh : MeshInstance3D
var outline : MeshInstance3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item.model != null:
		mesh = item.model.instantiate()
		add_child(mesh)
		
		mesh.create_convex_collision()
		mesh.get_child(0).get_child(0).reparent($Detection)
		mesh.get_child(0).queue_free()
		
		outline = MeshInstance3D.new() 
		outline.mesh = mesh.mesh.create_outline(0.03)
		outline.material_override = load("res://Assets/materials/outline_material.tres")
		add_child(outline)
		
		outline.hide()
		mouse_entered.connect(func():
			outline.show()
			)
		mouse_exited.connect(func():
			outline.hide()
			)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
