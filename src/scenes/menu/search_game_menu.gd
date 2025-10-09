extends Control

@onready var servers_cont: VBoxContainer = %"servers cont"
@onready var search_label: Label = %"search label"
@onready var search_animation_timer: Timer = $"search animation timer"
var server_info_button_scene := preload("res://src/scenes/button/server_info_button.tscn")

var ip := ""

var actual_servers := []
var servers_list := {}

var animation_frame := 2


func _ready() -> void:
	Signals.found_server.connect(_on_server_founded)
	LanDiscovery.setup_listener()


func _on_server_founded(serverip: String, data: Dictionary) -> void:
	if serverip == "":
		return
	
	if !servers_list.has(serverip):
		servers_list[serverip] = data["players_count"]
		create_button(serverip, data)
	elif servers_list[serverip] != data["players_count"]:
		update_button_info(serverip, data["players_count"])
	if !actual_servers.has(actual_servers):
		actual_servers.append(serverip)

func create_button(serverip: String, data: Dictionary) -> void:
	var server_info_button := server_info_button_scene.instantiate()
	server_info_button.server_ip = serverip
	server_info_button.player_name = data["player_name"]
	server_info_button.room_name = data["room_name"]
	server_info_button.player_skin = data["player_skin"]
	server_info_button.players_count = data["players_count"]
	servers_cont.add_child(server_info_button)

func update_button_info(serverip: String, players_count: int) -> void:
	for server_info_button in servers_cont.get_children():
		if server_info_button.server_ip == serverip:
			server_info_button.change_players_count(players_count)


func _on_exit_button_pressed() -> void:
	SceneManager.change_scene("main_menu")

func _on_host_button_pressed() -> void:
	Signals.on_host_button_pressed.emit()

func _on_check_servers_timer_timeout() -> void:
	for server in servers_list.keys():
		if !actual_servers.has(server):
			servers_list.erase(server)
			for server_info_button in servers_cont.get_children():
				if server_info_button.server_ip == server:
					server_info_button.queue_free()
	actual_servers.clear()


func _on_search_animation_timer_timeout() -> void:
	var dots := ""
	for i in animation_frame: 
		dots += "."
	search_label.text = "Поиск хостов" + dots
	animation_frame = animation_frame + 1 if animation_frame != 3 else 1
