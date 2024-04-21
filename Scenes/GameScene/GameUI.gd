extends Control

@export var win_scene : PackedScene
@export var lose_army_scene : PackedScene
@export var lose_sus_scene : PackedScene

func _ready():
	InGameMenuController.scene_tree = get_tree()

func _on_level_lost_sus():
	InGameMenuController.open_menu(lose_sus_scene, get_viewport())
	
func _on_level_lost_army():
	InGameMenuController.open_menu(lose_army_scene, get_viewport())

func _on_level_won():
	InGameMenuController.open_menu(win_scene, get_viewport())

func _on_level_loader_level_loaded():
	await $LevelLoader.current_level.ready
	if $LevelLoader.current_level.has_signal("level_won"):
		$LevelLoader.current_level.level_won.connect(_on_level_won)
	if $LevelLoader.current_level.has_signal("level_lost_sus"):
		$LevelLoader.current_level.level_lost.connect(_on_level_lost_sus)
	if $LevelLoader.current_level.has_signal("level_lost_army"):
		$LevelLoader.current_level.level_lost.connect(_on_level_lost_army)
	$LoadingScreen.close()

func _on_level_loader_levels_finished():
	InGameMenuController.open_menu(win_scene, get_viewport())

func _on_level_loader_level_load_started():
	$LoadingScreen.reset()
