extends Resource
class_name Item

enum Types { Resource, Equipment }
enum Quality { Bad, Good, Perfect }

@export var item_name : String
@export var icon : Texture2D
@export var item_type : Types
@export var model : PackedScene
@export var quality : Quality =  Quality.Good
@export var description : String

var quality_str : String :
	get:
		return Quality.find_key(quality)

var item_type_str : String :
	get:
		return Types.find_key(item_type)
