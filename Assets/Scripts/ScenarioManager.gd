extends Node

class_name ScenarioManager

@export var badge_tex_placeholder: Array[Texture2D]

var days: Array[DayModel] = [
	DayModel.new(5, 0, 0),
	DayModel.new(4, 2, 0),
	DayModel.new(3, 2, 1),
	]

var active_day := days[0]
var customers_queue: Array[Customer] = []
var current_customer: Customer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func setup_day(day_num: int):
	active_day = days[day_num]
	var customers : Array[Customer] = []
	for i in active_day.soldier_count:
		customers.append(Customer.new(CustomerType.SOLDIER, badge_tex_placeholder[0]))
	for i in active_day.rebel_count:
		customers.append(Customer.new(CustomerType.REBEL, badge_tex_placeholder[1]))
	for i in active_day.agent_count:
		customers.append(Customer.new(CustomerType.AGENT, badge_tex_placeholder[2]))
		
	customers.shuffle()
	# Insert special customers
	customers_queue = customers
	
func get_current_customer() -> Customer:
	return current_customer;
	
func get_remaining_customers() -> int:
	return customers_queue.size()
	
func next_customer():
	current_customer = customers_queue.pop_front()
		
class DayModel:
	var soldier_count: int
	var rebel_count: int
	var agent_count: int
	# Day rules
	# Special visit
	
	func _init(soldiers: int, rebels: int, agents: int):
		soldier_count = soldiers
		rebel_count = rebels
		agent_count = agents

#class RuleModel:
	#var 
