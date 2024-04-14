extends PanelContainer

@export var item : Item

@onready var icon: TextureRect = %Icon
@onready var header: Label = %Header
@onready var description: Label = %Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item == null: 
		return
	if item.icon != null:
		icon.texture = item.icon
	header.text = item.item_name if !item.item_name.is_empty() else "Empty name"
	description.text = "Quality: " + item.Quality.find_key(item.quality) + (("\nDescription: " + item.description) if !item.description.is_empty() else "")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
