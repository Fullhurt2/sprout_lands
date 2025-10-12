extends Node

const DAY_LENGTH := 36.0 # в сек.
const CLEAR_DAY_CHANCE := 4
const CLOUDY_DAY_CHANCE := 4
const RAINY_DAY_CHANCE := 2

var days_lived := 0
var day_of_the_week := 0 # [0-6]
var time := 0.0 # в сек.
var day_type := 0

var asleep_persons_count := 0
var is_sleeping := false


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	Signals.fell_asleep.connect(_on_fell_asleep)
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	time = clampf(time + delta, 0.0, DAY_LENGTH)

func start_time() -> void:
	set_physics_process(true)
	_set_day_type()


func _on_fell_asleep() -> void:
	is_sleeping = !is_sleeping
	rpc_id(1, "_add_asleep_person", is_sleeping)

@rpc("any_peer", "call_local")
func _add_asleep_person(peer_sleeping_status: bool) -> void:
	asleep_persons_count = asleep_persons_count + 1 if peer_sleeping_status else asleep_persons_count - 1
	if asleep_persons_count >= multiplayer.get_peers().size() + 1:
		asleep_persons_count = 0
		rpc("_set_new_day", _set_day_type())

@rpc("call_local")
func _set_new_day(new_day_type: int) -> void:
	days_lived += 1
	day_of_the_week = day_of_the_week + 1 if day_of_the_week != 6 else 0
	time = 0.0
	day_type = new_day_type
	Signals.day_passed.emit()
	is_sleeping = false

func _set_day_type() -> int:
	var total = CLEAR_DAY_CHANCE + CLOUDY_DAY_CHANCE + RAINY_DAY_CHANCE
	var roll = randi() % total
	if roll < CLEAR_DAY_CHANCE:
		return 0
	elif roll < CLEAR_DAY_CHANCE + CLOUDY_DAY_CHANCE:
		return 1
	else:
		return 2


func _on_peer_connected(id: int) -> void:
	if multiplayer.is_server():
		rpc_id(id, "_set_time_on_client", days_lived, day_of_the_week, time, day_type)

@rpc("authority")
func _set_time_on_client(host_days_lived: int, host_day_of_the_week: int, host_time: float, host_day_type: int) -> void:
	days_lived = host_days_lived
	day_of_the_week = host_day_of_the_week
	time = host_time
	day_type = host_day_type
