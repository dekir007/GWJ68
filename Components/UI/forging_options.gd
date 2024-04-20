@tool
extends CanvasLayer

signal chosen(item : Item)

const CRAFTING_OPTION = preload("res://Components/UI/crafting_option.tscn")
# yes, bad
const DAGGER_BAD = preload("res://Components/Items/dagger_bad.tres")
const DAGGER_GOOD = preload("res://Components/Items/dagger_good.tres")
#const DAGGER_PERFECT = preload("res://Components/Items/dagger_perfect.tres")
const INGOT = preload("res://Components/Items/ingot.tres")
const SWORD_BAD = preload("res://Components/Items/sword_bad.tres")
const SWORD_GOOD = preload("res://Components/Items/sword_good.tres")
#const SWORD_PERFECT = preload("res://Components/Items/sword_perfect.tres")

@export var item_node : ItemNode

@onready var options: VBoxContainer = %Options
@onready var close_button: TextureButton = $CloseButton

@onready var hover_color = close_button.modulate.darkened(.2)
@onready var normal_color = close_button.modulate 

#var dict : Dictionary = {
	#INGOT : [
		#SWORD_BAD,
		#DAGGER_BAD,
	#],
	#SWORD_BAD : [SWORD_GOOD],
	#SWORD_GOOD : [SWORD_PERFECT],
	#SWORD_PERFECT : [],
	#DAGGER_BAD : [DAGGER_GOOD],
	#DAGGER_GOOD : [DAGGER_PERFECT],
	#DAGGER_PERFECT : [],
#}

func _ready() -> void:
	if item_node == null:
		return
	
	for ch in options.get_children():
		ch.queue_free()
	for new_item in get_new_items(item_node.item):
		var cr = CRAFTING_OPTION.instantiate()
		cr.item = new_item
		cr.clicked.connect(_on_clicked)
		options.add_child(cr)
	pass


func get_new_items(item : Item):
	var res = []
	if item.item_name == "Iron ingot":
		if item_node.temperature < item_node.too_hot:
			res.append(SWORD_GOOD)
			res.append(DAGGER_GOOD)
		else:
			res.append(SWORD_BAD)
			res.append(DAGGER_BAD)
	elif item_node.temperature < item_node.too_hot:
		var it = load("res://Components/Items/%s_%s.tres" % [item.item_name.to_lower(), Item.Quality.find_key(wrapi(item.quality + 1, 0, Item.Quality.keys().size()))])
		res.append(it)
	else:
		var it = load("res://Components/Items/%s_%s.tres" % [item.item_name.to_lower(), Item.Quality.find_key(clamp(item.quality - 1, 0, Item.Quality.keys().size() - 1))])
		res.append(it)
	return res

func _on_clicked(new_item : Item):
	chosen.emit(new_item)
	print("chosen ", new_item)
	queue_free()


func _on_close_button_mouse_entered() -> void:
	close_button.modulate = hover_color
	pass # Replace with function body.


func _on_close_button_mouse_exited() -> void:
	close_button.modulate = normal_color
	pass # Replace with function body.


func _on_close_button_pressed() -> void:
	queue_free()
	pass # Replace with function body.
