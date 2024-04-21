extends Node3D

const INGOT = preload("res://Components/Items/ingot.tres")
const ITEM_NODE = preload("res://Components/ItemNodes/item_node.tscn")

@onready var camera: Camera3D = $Camera3D
@onready var equipment_distribution: CanvasLayer = $EquipmentDistribution
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hammer: Node3D = %Hammer
@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var ingot_pivot: Marker3D = $IngotPivot
@onready var get_ingots_layer: CanvasLayer = $GetIngotsLayer

var items_on_table : Array[ItemNode] = []

var near_anvil : = false

func _ready() -> void:
	hammer.hide()


func _on_button_pressed() -> void:
	if ingot_pivot.get_child_count() == 0:
		var ingot = ITEM_NODE.instantiate()
		ingot.item = INGOT
		ingot_pivot.add_child(ingot)
	pass # Replace with function body.
