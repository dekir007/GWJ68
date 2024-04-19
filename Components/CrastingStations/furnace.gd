extends CraftingStation

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
	if current_item.temperature < 1300:
		# TODO play normal sound
		current_item.temperature += 150 * delta
	else: 
		# TODO play "too hot"
		current_item.temperature += 50 * delta
	pass # Replace with function body.
