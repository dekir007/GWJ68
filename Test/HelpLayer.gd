extends CanvasLayer

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("help"):
		if visible:
			hide()
		else:
			show()
