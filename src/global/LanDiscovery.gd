extends Node

const LISTEN_PORT := 8911
var broadcast_address := "255.255.255.255"

var _room_info := {
	"player_name": "Player",
	"room_name": "room name",
	"player_skin": "classic",
	"players_count": 0
	}

var _listener : PacketPeerUDP
var _broadcaster : PacketPeerUDP
var _timer : Timer
var is_listening := false

func _ready() -> void:
	for addr in IP.get_local_addresses():
		if addr.begins_with("192.168.") or addr.begins_with("10."):
			var parts := addr.split(".")
			parts[3] = "255"
			broadcast_address = ".".join(parts)
			break

func setup_listener() -> void:
	cleanup()
	_listener = PacketPeerUDP.new()
	var err := _listener.bind(LISTEN_PORT, "*")
	if err:
		push_error("[listener] UDP bind ошибка: %s" % err)
		return
	is_listening = true

func setup_broadcaster() -> void:
	cleanup()
	_broadcaster = PacketPeerUDP.new()
	_broadcaster.set_broadcast_enabled(true)
	_broadcaster.set_dest_address(broadcast_address, LISTEN_PORT)
	var err := _broadcaster.bind(0)
	if err:
		push_error("[broadcast] UDP bind ошибка: %s" % err)
		return

	_timer = Timer.new()
	_timer.wait_time = 1.0
	_timer.one_shot = false
	_timer.autostart = true
	_timer.timeout.connect(_on_broadcast_timer_timeout)
	add_child(_timer)

func _process(_delta) -> void:
	if !is_listening:
		return
	while _listener.get_available_packet_count() > 0:
		var server_ip := _listener.get_packet_ip()
		var bytes := _listener.get_packet()
		var text := bytes.get_string_from_utf8()
		var result = JSON.parse_string(text)
		Signals.found_server.emit(server_ip, result)

func _on_broadcast_timer_timeout() -> void:
	_room_info.player_name = Global.player_name
	_room_info.room_name = Global.room_name
	_room_info.player_skin = Global.player_skin
	_room_info.players_count = RpcManager.players_count
	
	var json := JSON.stringify(_room_info)
	_broadcaster.put_packet(json.to_utf8_buffer())

func _exit_tree() -> void:
	cleanup()

func cleanup() -> void:
	is_listening = false
	if _listener:
		_listener.close()
	if _broadcaster:
		_broadcaster.close()
	if _timer:
		_timer.stop()
		_timer.queue_free()
