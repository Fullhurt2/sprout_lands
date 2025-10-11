extends Node

var player_animations_cache := {}
var player_icons_cache := {}
var player_items_cache := {}
var weather_icons_cache := {}

var moving_frame_size := Vector2(20, 20)
var chopping_frame_size := Vector2(34, 32)
var tilling_frame_size := Vector2(26, 30)
var watering_frame_size := Vector2(58, 26)

func get_player_animations(skin: String) -> SpriteFrames:
	if !player_animations_cache.has(skin):
		var animations := SpriteFrames.new()
		_add_animation(animations, "idle", skin, 8)
		_add_animation(animations, "move", skin, 8)
		_add_animation(animations, "chopping", skin, 8)
		_add_animation(animations, "tilling", skin, 8)
		_add_animation(animations, "watering", skin, 13)
		_add_animation(animations, "planting", skin, 13)
		player_animations_cache[skin] = animations
	return player_animations_cache[skin]

func _add_animation(animations: SpriteFrames, animation_name: String, skin: String, frames_count: int) -> void:
	var sprite_list := load("res://res/sprites/player animation/"+ skin +"/"+ animation_name +".png")
	var dir = "b"
	for i in 3:
		animations.add_animation(dir + "_" + animation_name)
		animations.set_animation_loop(dir + "_" + animation_name, true)
		animations.set_animation_speed(dir + "_" + animation_name, 10.0)
		
		var frame_size: Vector2
		if animation_name == "chopping":
			frame_size = chopping_frame_size
		elif animation_name == "tilling":
			frame_size = tilling_frame_size
		elif animation_name == "watering" or animation_name == "planting":
			frame_size = watering_frame_size
		else:
			frame_size = moving_frame_size
		
		for frame in range(frames_count):
			var region := Rect2(frame * frame_size.x, i * frame_size.y, frame_size.x, frame_size.y)
			var subtexture := AtlasTexture.new()
			subtexture.atlas = sprite_list
			subtexture.region = region
			animations.add_frame(dir + "_" + animation_name, subtexture)
		
		dir = "s" if dir == "t" else "t"


func get_player_icon(skin: String) -> Texture2D:
	if !player_icons_cache.has(skin):
		player_icons_cache[skin] = load("res://res/ui/icons/player/"+ skin +"_icon.png")
	return player_icons_cache[skin]

func get_item_icon(item: String) -> Texture2D:
	if !player_items_cache.has(item):
		player_items_cache[item] = load("res://res/ui/icons/item/"+ item +"_icon.png")
	return player_items_cache[item]
