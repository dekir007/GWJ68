extends Node

class_name ScenarioManager

@export var badge_tex_soldier: Array[Texture2D]
@export var badge_tex_rebel: Array[Texture2D]
@export var badge_tex_agent: Array[Texture2D]

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
	active_day = days[day_num - 1]
	var customers : Array[Customer] = []
	for i in active_day.soldier_count:
		customers.append(Customer.new(Customer.Type.SOLDIER, get_rand_badge(Customer.Type.SOLDIER)))
	for i in active_day.rebel_count:
		customers.append(Customer.new(Customer.Type.REBEL, get_rand_badge(Customer.Type.REBEL)))
	for i in active_day.agent_count:
		customers.append(Customer.new(Customer.Type.AGENT, get_rand_badge(Customer.Type.AGENT)))
		
	customers.shuffle()
	# Insert special customers
	customers_queue = customers
	
func get_current_customer() -> Customer:
	return current_customer;
	
func get_remaining_customers() -> int:
	return customers_queue.size()
	
func is_last_day(day: int) -> bool:
	return day >= days.size()
	
func get_remaining_days(day: int) -> int:
	return days.size() - day
	
func next_customer():
	current_customer = customers_queue.pop_front()
	
func get_rand_badge(customer_type: Customer.Type) -> Texture2D:
	match customer_type:
		Customer.Type.SOLDIER:
			var i = randi() % badge_tex_soldier.size()
			print("Soldier: %d" % i)
			return badge_tex_soldier[i]
		Customer.Type.REBEL:
			var i = randi() % badge_tex_rebel.size()
			print("Rebel: %d" % i)
			return badge_tex_rebel[i]
		Customer.Type.AGENT:
			var i = randi() % badge_tex_agent.size()
			print("Agent: %d" % i)
			return badge_tex_agent[i]
		_:
			return badge_tex_soldier[0]
		
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
