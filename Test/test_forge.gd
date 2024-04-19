extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var equipment_distribution: CanvasLayer = $EquipmentDistribution
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hammer: Node3D = %Hammer

var items_on_table : Array[ItemNode] = []

var near_anvil : = false

func _ready() -> void:
	hammer.hide()

