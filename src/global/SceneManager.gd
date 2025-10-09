extends Node

var main: Node

var Scenes := {
	"main_menu": preload("res://src/scenes/menu/main_menu.tscn"),
	"test_level": preload("res://src/scenes/level/test_level.tscn"),
	"search_game_menu": preload("res://src/scenes/menu/search_game_menu.tscn"),
	"profile_menu": preload("res://src/scenes/menu/profile_menu.tscn")
,}

func change_scene(scene: String) -> void:
	Signals.change_scene.emit()
	if main: main.change_scene(Scenes.get(scene))
