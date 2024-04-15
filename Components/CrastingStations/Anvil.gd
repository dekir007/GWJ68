extends CraftingStation
class_name Anvil

@onready var outline: MeshInstance3D = $MeshInstance3D/Outline

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
