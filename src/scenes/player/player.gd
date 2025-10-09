class_name Player
extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var fsm: Node = $FSM
@onready var nickname_label: Label = %nickname
@onready var marker_node: Node2D = $"marker node"
@onready var marker: Marker2D = $"marker node/marker"

const SPEED := 80.0

var skin := "classic"
var current_animation := ""
var nickname := "null"

var move_dir := Vector2.ZERO
var dir := "b"


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	animations.sprite_frames = SpriteLoader.get_player_animations(skin)
	fsm.init(self)
	
	if multiplayer.is_server():
		nickname_label.text = nickname
	
	Signals.tile_target_start.emit(Vector2(global_position))

func _process(delta: float) -> void:
	fsm.process_frame(delta)

func _physics_process(delta: float) -> void:
	fsm.process_physics(delta)


func play_animation(animation: String) -> void:
	current_animation = dir + "_" + animation
	animations.play(current_animation)
	send_state("current_animation", current_animation)

func send_state(property: String, value) -> void:
	RpcManager.rpc("sync_state", property, value)


func _on_ready() -> void:
	RpcManager.add_new_player(self)
	nickname_label.text = nickname

func _on_peer_connected(_peer_id) -> void:
	send_state("current_animation", current_animation)
	send_state("flip_h" ,animations.flip_h)
	send_state("global_position" ,global_position)
