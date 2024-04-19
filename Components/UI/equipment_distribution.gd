extends CanvasLayer

const ITEM_CONTAINER = preload("res://Components/UI/item_container.tscn")

@onready var equipment: VBoxContainer = %Equipment

func get_items(items):
	for eq in equipment.get_children():
		eq.queue_free()
	for item in items:
		var item_container = ITEM_CONTAINER.instantiate()
		item_container.item = item
		equipment.add_child(item_container)
