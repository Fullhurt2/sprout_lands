extends TextureButton

@onready var icon: TextureRect = $icon

var skin := "classic"

func _ready() -> void:
	if skin == Global.player_skin:
		set_pressed_no_signal(true)
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	button_group = load("res://src/resources/icon_button_group.tres")
	icon.texture = SpriteLoader.get_player_icon(skin)


func _on_button_up() -> void:
	icon.position.y -= 2

func _on_button_down() -> void:
	icon.position.y += 2

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Signals.icon_button_pressed.emit(skin)
		icon.position.y += 2
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		icon.position.y -= 2
		mouse_filter = Control.MOUSE_FILTER_STOP
		
