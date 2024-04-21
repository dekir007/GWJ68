extends RefCounted

class_name Equipment

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

enum Type {
	SWORD
}

var quality: Quality
var type: Type

func _init(equip_quality: Quality, equip_type: Type):
	quality = equip_quality
	type = equip_type
