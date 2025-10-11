extends State

@export var idle: State
@export var move: State

var planting_finished := false
var timer := Timer.new()

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func enter() -> void:
	timer.start(1.3)
	parent.play_animation("planting")

func process_frame(_delta: float) -> State:
	if Global.player_direction != Vector2.ZERO:
		return move
	if planting_finished == true:
		return idle
	return null

func process_physics(_delta: float) -> State:
	return null

func exit() -> void:
	timer.stop()
	planting_finished = false

func _on_timer_timeout() -> void:
	planting_finished = true
	Signals.check_planting.emit(Global.target_tile * 16)
