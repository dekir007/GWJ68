extends RefCounted

class_name Customer

var type: Type
var badge: Texture2D
var wanted_equipment: Equipment.Type
var request_text: String:
	get:
		match (wanted_equipment):
			Equipment.Type.SWORD:
				return "I want a sword"
			_:
				return "I don't know what I want"
	
func _init(customer_type: Type, badge_texture: Texture2D, equipment_type: Equipment.Type):
	type = customer_type
	badge = badge_texture
	wanted_equipment = equipment_type

enum Type {
	SOLDIER,
	REBEL,
	AGENT,
	SPECIAL
}

