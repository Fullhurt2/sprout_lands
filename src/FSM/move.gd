extends State

@export var idle: State
var run_mod := 1.0

var dir := "":
	set(value):
		if dir != value:
			if value == "l" or value == "r":
				parent.send_state("flip_h", parent.animations.flip_h)
			parent.dir = value if value != "l" and value != "r" else "s"
			parent.play_animation("move")
		dir = value

func _ready() -> void:
	Signals.interact_button_pressed.connect(_is_interact_button_pressed)

func enter() -> void:
	parent.play_animation("move")
	Signals.change_interact.emit("run")

func process_frame(_delta: float) -> State:
	change_dir()
	if Global.player_direction == Vector2.ZERO:
		return idle
	return null

func process_physics(_delta: float) -> State:
	parent.move_dir = Global.player_direction
	parent.velocity = parent.velocity.lerp(parent.move_dir * parent.SPEED * run_mod, 0.25)
	parent.move_and_slide()
	parent.send_state("new_position" ,parent.global_position)
	parent.marker_node.rotation = rotate_marker()
	return null

func exit() -> void:
	run_mod = 1.0


func change_dir() -> void:
	var move_dir_dot := parent.move_dir.dot(Vector2.UP)
	
	if move_dir_dot > 0.65:
		dir = "t"
	elif move_dir_dot < -0.65:
		dir = "b"
	elif parent.move_dir.x < 0:
		parent.animations.flip_h = true
		dir = "l"
	elif parent.move_dir.x > 0:
		parent.animations.flip_h = false
		dir = "r"

func rotate_marker() -> float:
	var rad = parent.marker_node.rotation
	if Global.player_direction != Vector2.ZERO:
		rad = atan2(Global.player_direction.y, Global.player_direction.x)
		var x = floor(parent.marker.global_position.x / 16)
		var y = floor(parent.marker.global_position.y / 16)
		if Vector2i(x, y) != Global.target_tile:
			Global.target_tile = Vector2i(x, y)
	return rad


func _is_interact_button_pressed(is_pressed: bool, purpose: String) -> void:
	if purpose == "run" and is_pressed:
		run_mod = 1.5
	elif purpose == "run" and !is_pressed:
		run_mod = 1.0
