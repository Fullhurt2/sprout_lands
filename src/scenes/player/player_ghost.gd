extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var nickname_label: Label = %nickname

var skin := "classic"
var new_position := Vector2.ZERO
var nickname := "null"

var current_animation: String:
	set(value):
		current_animation = value
		play_animation(current_animation)

var flip_h: bool:
	set(value):
		flip_h = value
		animations.flip_h = flip_h


func _ready() -> void:
	nickname_label.text = nickname
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	animations.sprite_frames = SpriteLoader.get_player_animations(skin)
	play_animation("b_idle")

func _physics_process(_delta: float) -> void:
	if new_position != Vector2.ZERO:
		global_position = global_position.lerp(new_position, 0.25)


func play_animation(animation_name: String) -> void:
	animations.play(animation_name)


func _on_peer_disconnected(peer_id: int) -> void:
	if get_multiplayer_authority() == peer_id:
		RpcManager.remove_player(peer_id)

func _on_ready() -> void:
	RpcManager.add_new_player(self)
