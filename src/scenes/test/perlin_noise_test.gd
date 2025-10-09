extends Node2D

var draw_size := Vector2i(639, 359)
var noise_scale = 0.008
var draw_seed := 1565165
var draw_value: Vector2

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

func _ready() -> void:
	create_noise()

func create_noise() -> void:
	draw_seed = randi()
	draw_value = Vector2(randf_range(0.46, 0.48), randf_range(0.52, 0.56))
	tile_map_layer.clear()
	
	var noise := FastNoiseLite.new()
	noise.seed = draw_seed
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = noise_scale
	
	for x in draw_size.x:
		for y in draw_size.y:
			var noise_value = noise.get_noise_2d(x, y)
			noise_value = (noise_value + 1) / 2
			
			if draw_value.x < noise_value and noise_value < draw_value.y:
				tile_map_layer.set_cell(Vector2i(x, y), 1, Vector2i(1, 0))


func _on_reset_button_pressed() -> void:
	create_noise()
