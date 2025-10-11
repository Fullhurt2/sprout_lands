extends Node2D

@onready var objects: Node2D = $objects
@onready var tile_target: AnimatedSprite2D = $"objects/tile target"
@onready var tile_target_2: AnimatedSprite2D = $"objects/tile target2"

var spawn_pos := Vector2(100, 100)
var player_scene := preload("res://src/scenes/player/player.tscn")
var player_ghost_scene := preload("res://src/scenes/player/player_ghost.tscn")
var plant_scene := preload("res://src/scenes/other/plant.tscn")

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	Signals.planting.connect(_planting)
	spawn_player(multiplayer.get_unique_id())
	TimeManager.start_time()

func _on_peer_connected(id: int) -> void:
	rpc_id(id, "remote_spawn", Global.player_skin, Global.player_name)
	if multiplayer.is_server():
		rpc_id(id, "create_plants", Global.plants_array)

@rpc("any_peer")
func remote_spawn(skin: String, player_name: String) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	var player_ghost = player_ghost_scene.instantiate()
	player_ghost.set_multiplayer_authority(sender_id)
	player_ghost.nickname = player_name
	player_ghost.skin = skin
	player_ghost.global_position = spawn_pos
	objects.add_child(player_ghost)

func spawn_player(peer_id: int) -> void:
	var player = player_scene.instantiate() as Player
	player.set_multiplayer_authority(peer_id)
	player.nickname = Global.player_name
	player.skin = Global.player_skin
	player.global_position = spawn_pos
	objects.add_child(player)
	
	tile_target.global_position = spawn_pos
	tile_target_2.global_position = spawn_pos


@rpc("any_peer")
func create_plants(plants_array: Dictionary) -> void:
	for plant in plants_array:
		_planting(plant, plants_array[plant]["plant_name"], plants_array[plant]["stage"])

func _planting(pos: Vector2i, plant_name: String, stage: int) -> void:
	var plant := plant_scene.instantiate() as Node2D
	plant.global_position = pos
	plant.plant_name = plant_name
	plant.current_stage = stage
	objects.add_child(plant)
