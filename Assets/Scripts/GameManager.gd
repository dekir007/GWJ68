extends Node

var evil_ap := 0
var rebel_ap := 0
var suspicion := 0

@export var scenario_manager: ScenarioManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass

func serve_customer(equipment: Equipment):
	var customer = scenario_manager.current_customer
	match customer.type:
		Customer

enum Quality {
	NONE,
	
	UNUSABLE,
	
	SHODDY,
	POOR,
	
	OK,
	GOOD,
	
	GREAT,
	PERFECT
}

class Equipment:
	var quality: Quality

class Sword extends Equipment:
	pass
