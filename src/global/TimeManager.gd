extends Node

const DAY_LENGTH := 36.0 # в сек.
const CLEAR_DAY_CHANCE := 4
const CLOUDY_DAY_CHANCE := 4
const RAINY_DAY_CHANCE := 2

var days_lived := 0
var day_of_the_week := 0 # [0-6]
var time := 0.0 # в сек.
var day_type := 0


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	time = clampf(time + delta, 0.0, DAY_LENGTH)

func start_time() -> void:
	set_physics_process(true)
	set_day_type()


func set_new_day() -> void:
	days_lived += 1
	day_of_the_week = day_of_the_week + 1 if day_of_the_week != 6 else 0
	time = 0.0
	set_day_type()

func set_day_type() -> void:
	var total = CLEAR_DAY_CHANCE + CLOUDY_DAY_CHANCE + RAINY_DAY_CHANCE
	var roll = randi() % total

	if roll < CLEAR_DAY_CHANCE:
		day_type = 0
	elif roll < CLEAR_DAY_CHANCE + CLOUDY_DAY_CHANCE:
		day_type = 1
	else:
		day_type = 2

func _on_peer_connected(id: int) -> void:
	if multiplayer.is_server():
		rpc_id(id, "set_time_on_client", days_lived, day_of_the_week, time, day_type)

@rpc("authority")
func set_time_on_client(host_days_lived: int, host_day_of_the_week: int, host_time: float, host_day_type: int) -> void:
	days_lived = host_days_lived
	day_of_the_week = host_day_of_the_week
	time = host_time
	day_type = host_day_type
