extends Control

@onready var icons_grid_cont: GridContainer = %"icons grid cont"
@onready var player_name_line: LineEdit = %"player name line"

var change_icon_button_scene := preload("res://src/scenes/button/change_icon_button.tscn")
var choosed_skin := Global.player_skin
var choosed_name := Global.player_name

func _ready() -> void:
	Signals.icon_button_pressed.connect(_on_icon_button_pressed)
	
	for skin in Data.all_skins:
		create_change_icon_button(skin)
	
	player_name_line.text = choosed_name


func create_change_icon_button(skin: String) -> void:
	var change_icon_button := change_icon_button_scene.instantiate()
	change_icon_button.skin = skin
	icons_grid_cont.add_child(change_icon_button)


func _on_icon_button_pressed(skin: String) -> void:
	choosed_skin = skin

func _on_player_name_line_text_changed(new_text: String) -> void:
	choosed_name = new_text

func _on_apply_button_pressed() -> void:
	Global.player_skin = choosed_skin
	Global.player_name = choosed_name
	SceneManager.change_scene("main_menu")
