extends RefCounted

class_name Customer

var type: Type
var badge: Texture2D
	
func _init(customer_type: Type, badge_texture: Texture2D):
	type = customer_type
	badge = badge_texture

enum Type {
	SOLDIER,
	REBEL,
	AGENT,
	SPECIAL
}
