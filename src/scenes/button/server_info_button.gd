extends TextureButton

@onready var host_name_label: Label = %"host name label"
@onready var room_name_label: Label = %"room name label"
@onready var server_icon: TextureRect = %"server icon"
@onready var players_count_label: Label = %"players count label"

@onready var hbox_cont: HBoxContainer = $"hbox cont"

var server_ip: String
var player_name: String
var room_name: String
var player_skin: String
var players_count: int

func _ready() -> void:
	host_name_label.text = player_name
	room_name_label.text = room_name
	server_icon.texture = SpriteLoader.get_player_icon(player_skin)
	players_count_label.text = str(players_count) + "/4"

func change_players_count(actual_players_count: int) -> void:
	players_count_label.text = str(actual_players_count) + "/4"


func _on_pressed() -> void:
	Signals.join_game.emit(server_ip)
	LanDiscovery.cleanup()


func _on_button_down() -> void:
	hbox_cont.position.y += 2

func _on_button_up() -> void:
	hbox_cont.position.y -= 2
