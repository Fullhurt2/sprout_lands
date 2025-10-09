extends State

@export var move: State
@export var till: State
@export var chop: State
@export var water: State
@export var seed: State

var is_interacting := false

func _ready() -> void:
	Signals.interact_button_pressed.connect(_is_interact_button_pressed)

func enter() -> void:
	is_interacting = false
	parent.play_animation("idle")
	Signals.change_interact.emit("interact")

func process_frame(_delta: float) -> State:
	if Global.player_direction != Vector2.ZERO:
		return move
	if is_interacting and Global.choosed_item != null:
		if Global.choosed_item.type == "Hoe":
			return till
		elif Global.choosed_item.type == "Axe":
			return chop
		elif Global.choosed_item.type == "Water_can":
			return water
		elif Global.choosed_item.type == "Seed":
			return seed
	return null

func process_physics(_delta: float) -> State:
	return null

func exit() -> void:
	is_interacting = false


func _is_interact_button_pressed(is_pressed: bool, purpose: String) -> void:
	if is_pressed and purpose == "interact":
		is_interacting = true
	if !is_pressed and purpose == "interact":
		is_interacting = false
