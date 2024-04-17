extends PanelContainer

signal clicked(new_item : Item)

@export var item : Item
@onready var label: Label = $MarginContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item == null:
		return
	label.text = item.item_name + " (%s)" % Item.Quality.find_key(item.quality)
	pass # Replace with function body.

func _on_button_pressed() -> void:
	clicked.emit(item)
	pass # Replace with function body.
