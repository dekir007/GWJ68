extends Interactable
class_name CraftingStation

@export var current_item : ItemNode

@onready var state_chart: StateChart = $StateChart
@onready var pivot: Node3D = $Pivot


func get_item(item : ItemNode):
	current_item = item
	current_item.position = Vector3.ZERO
	current_item.parent = self
	pivot.add_child(item)

func take_item():
	pivot.remove_child(current_item)
	current_item.parent = null
	current_item = null
