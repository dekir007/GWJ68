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
