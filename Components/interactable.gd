extends Node3D
class_name Interactable

signal mouse_entered
signal mouse_exited
signal click(sender : Interactable, event : InputEvent)

@onready var detection: StaticBody3D = $Detection

func _on_detection_mouse_entered() -> void:
	#print("mouse_entered")
	mouse_entered.emit()
	pass # Replace with function body.


func _on_detection_mouse_exited() -> void:
	#print("mouse_exited")
	mouse_exited.emit()
	pass # Replace with function body.


func _on_detection_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	#print("fgfg")
	if event is InputEventMouseButton:
		#print("clicked")
		click.emit(self, event)
	pass # Replace with function body.
