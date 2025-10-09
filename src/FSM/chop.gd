extends State

@export var idle: State
@export var move: State

var tilling_finished := false
var timer := Timer.new()

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func enter() -> void:
	timer.start(2.4)
	parent.play_animation("chopping")

func process_frame(_delta: float) -> State:
	if Global.player_direction != Vector2.ZERO:
		return move
	if tilling_finished == true:
		return idle
	return null

func process_physics(_delta: float) -> State:
	return null

func exit() -> void:
	timer.stop()
	tilling_finished = false

func _on_timer_timeout() -> void:
	tilling_finished = true
