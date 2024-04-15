extends Interactable
class_name CraftingStation

@export var current_item : ItemNode

@onready var state_chart: StateChart = $StateChart
@onready var pivot: Node3D = $Pivot


func get_item(item : ItemNode):
	current_item = item
	current_item.position = Vector3.ZERO
	pivot.add_child(item)

func take_item() -> ItemNode:
	pivot.remove_child(current_item)
	return current_item
