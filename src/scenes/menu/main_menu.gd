extends Control

func _on_solo_button_pressed() -> void:
	Signals.on_solo_button_pressed.emit()

func _on_multiplayer_button_pressed() -> void:
	SceneManager.change_scene("search_game_menu")

func _on_profile_button_pressed() -> void:
	SceneManager.change_scene("profile_menu")
