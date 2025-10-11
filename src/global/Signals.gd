extends Node

@warning_ignore("unused_signal")
signal change_scene


@warning_ignore("unused_signal")
signal on_solo_button_pressed
@warning_ignore("unused_signal")
signal on_host_button_pressed
@warning_ignore("unused_signal")
signal on_join_button_pressed


@warning_ignore("unused_signal")
signal found_server(ip: String, data: Dictionary)
@warning_ignore("unused_signal")
signal server_removed(ip : String)
@warning_ignore("unused_signal")
signal join_game(ip : String)
@warning_ignore("unused_signal")
signal icon_button_pressed(skin: String)


@warning_ignore("unused_signal")
signal tile_target_start(pos: Vector2)
@warning_ignore("unused_signal")
signal tile_target_changed(pos: Vector2)


@warning_ignore("unused_signal")
signal inventory_button_pressed(is_hotbar_button: bool, index: int)
@warning_ignore("unused_signal")
signal change_interact(purpose: String)
@warning_ignore("unused_signal")
signal interact_button_pressed(is_pressed: bool, purpose: String)


@warning_ignore("unused_signal")
signal tilling_tile(pos: Vector2i)
@warning_ignore("unused_signal")
signal check_planting(pos: Vector2i)
@warning_ignore("unused_signal")
signal planting(pos: Vector2i, plant_name: String, stage: int)


@warning_ignore("unused_signal")
signal day_passed
@warning_ignore("unused_signal")
signal fell_asleep
