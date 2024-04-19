extends CraftingStation
class_name Waterpot

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
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_has_item_state_processing(delta: float) -> void:
	# would be great to increase it according to a curve 
	if current_item.temperature > 500:
		# TODO play "too hot" for water and a lot of smoke
		current_item.temperature -= 300 * delta
	elif current_item.temperature > 20: 
		# TODO play normal sound for water and less smoke
		current_item.temperature -= 150 * delta
	pass # Replace with function body.
