extends Node3D

@onready var pivots: Node3D = $Pivots

var markers : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	markers = pivots.get_children()
	pass # Replace with function body.

func put_item(item_node : ItemNode):
	for marker : Marker3D in markers:
		if marker.get_child_count() == 0:
			if item_node.parent != null:
				item_node.parent.take_item()
			#item_node.reparent(marker)
			marker.add_child(item_node)
			item_node.position = Vector3.ZERO
			item_node.rotation = Vector3.ZERO
			return
	push_warning("TABLE FULL")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
