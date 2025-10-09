extends Node

var gameport := 1234

func _ready() -> void:
	SceneManager.main = self
	SceneManager.change_scene("main_menu")
	Signals.on_solo_button_pressed.connect(_solo_game)
	Signals.on_host_button_pressed.connect(_host_game)
	Signals.join_game.connect(_join_game)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func change_scene(scene: PackedScene):
	for child in get_children(): child.queue_free()
	add_child(scene.instantiate())


func _solo_game() -> void:
	var peer := WebSocketMultiplayerPeer.new()
	peer.create_server(0)
	multiplayer.multiplayer_peer = peer
	
	SceneManager.change_scene("test_level")

func _host_game() -> void:
	var peer := WebSocketMultiplayerPeer.new()
	peer.create_server(1234)
	multiplayer.multiplayer_peer = peer
	
	LanDiscovery.setup_broadcaster()
	SceneManager.change_scene("test_level")

func _join_game(ip) -> void:
	LanDiscovery.cleanup()
	var peer := WebSocketMultiplayerPeer.new()
	peer.create_client("ws://" + ip + ":" + str(gameport))
	multiplayer.multiplayer_peer = peer


func _on_connected_to_server() -> void:
	SceneManager.change_scene("test_level")

func _on_server_disconnected() -> void:
	LanDiscovery.cleanup()
	SceneManager.change_scene("main_menu")
