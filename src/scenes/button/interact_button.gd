extends TouchScreenButton

@onready var icon: TextureRect = $icon

var button_texture_normal := preload("res://res/ui/hud/button/circle_button_normal_72x72.png")
var button_texture_pressed := preload("res://res/ui/hud/button/circle_button_pressed_72x72.png")

var interact_icon_normal := preload("res://res/ui/hud/button/interact_icon_normal.png")
var interact_icon_pressed := preload("res://res/ui/hud/button/interact_icon_pressed.png")
var run_icon_normal := preload("res://res/ui/hud/button/run_icon_normal.png")
var run_icon_pressed := preload("res://res/ui/hud/button/run_icon_pressed.png")

var start_purpose := "interact"
var current_purpose := ""

func _ready() -> void:
	Signals.change_interact.connect(change_purpose)
	change_purpose(start_purpose)

func change_purpose(purpose: String) -> void:
	_on_released()
	current_purpose = purpose
	change_status(false)

func change_status(status: bool) -> void:
	texture_normal = button_texture_pressed if status else button_texture_normal
	match current_purpose:
		"interact":
			icon.texture = interact_icon_pressed if status else interact_icon_normal
		"run":
			icon.texture = run_icon_pressed if status else run_icon_normal


func _on_pressed() -> void:
	change_status(true)
	Signals.interact_button_pressed.emit(true, current_purpose)


func _on_released() -> void:
	change_status(false)
	Signals.interact_button_pressed.emit(false ,current_purpose)
