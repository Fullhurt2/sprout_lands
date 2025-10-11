extends Node

var player_name := "Player"
var room_name := "room name"
var player_skin := "classic"


var player_direction := Vector2.ZERO
var choosed_hotbar_slot := 0
var choosed_item: Item
var target_tile: Vector2i:
	set(value):
		target_tile = value
		Signals.tile_target_changed.emit(Vector2(target_tile * 16))


var parallax_scroll_offset := Vector2(0, 0)


var plants_array := {}
