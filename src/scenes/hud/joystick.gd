extends Control

@onready var big_circle = %"big circle"
@onready var small_circle = %"small circle"

var active_id := -1
var joystick_radius := 0.0
var joystick_dir := Vector2.ZERO:
	set(value):
		joystick_dir = value
		Global.player_direction = value

func _ready():
	joystick_radius = big_circle.size.x / 2
	mouse_filter = MOUSE_FILTER_IGNORE

func _unhandled_input(event: InputEvent):
	if event is InputEventScreenTouch:
		if event.pressed and active_id == -1 and _is_inside(event.position):
			active_id = event.index
			_process_input(event.position)
		elif not event.pressed and event.index == active_id:
			_reset_joystick()

	elif event is InputEventScreenDrag and event.index == active_id:
		_process_input(event.position)

func _is_inside(pos: Vector2) -> bool:
	var center = big_circle.global_position + big_circle.texture.get_size() / 2
	return center.distance_to(pos) <= joystick_radius

func _process_input(pos: Vector2):
	var center = big_circle.global_position + big_circle.texture.get_size() / 2
	var vec = pos - center
	var dir = vec.normalized()
	var distance = min(vec.length(), joystick_radius)

	joystick_dir = dir
	small_circle.position = dir * distance

func _reset_joystick():
	joystick_dir = Vector2.ZERO
	active_id = -1
	small_circle.position = Vector2.ZERO
