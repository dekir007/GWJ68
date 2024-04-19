@tool
extends CanvasLayer

signal chosen(item : Item)

const CRAFTING_OPTION = preload("res://Components/UI/crafting_option.tscn")
# yes, bad
const DAGGER_BAD = preload("res://Components/Items/dagger_bad.tres")
const DAGGER_GOOD = preload("res://Components/Items/dagger_good.tres")
const DAGGER_PERFECT = preload("res://Components/Items/dagger_perfect.tres")
const INGOT = preload("res://Components/Items/ingot.tres")
const SWORD_BAD = preload("res://Components/Items/sword_bad.tres")
const SWORD_GOOD = preload("res://Components/Items/sword_good.tres")
const SWORD_PERFECT = preload("res://Components/Items/sword_perfect.tres")

@export var item : Item

@onready var options: VBoxContainer = %Options

var dict : Dictionary = {
	INGOT : [
		SWORD_BAD,
		DAGGER_BAD,
	],
	SWORD_BAD : [SWORD_GOOD],
	SWORD_GOOD : [SWORD_PERFECT],
	SWORD_PERFECT : [],
	DAGGER_BAD : [DAGGER_GOOD],
	DAGGER_GOOD : [DAGGER_PERFECT],
	DAGGER_PERFECT : [],
}

func _ready() -> void:
	if item == null:
		return
	for ch in options.get_children():
		ch.queue_free()
	for new_item in dict[item]:
		var cr = CRAFTING_OPTION.instantiate()
		cr.item = new_item
		cr.clicked.connect(_on_clicked)
		options.add_child(cr)
	pass

func _on_clicked(new_item : Item):
	chosen.emit(new_item)
	print("chosen ", new_item)
	queue_free()
