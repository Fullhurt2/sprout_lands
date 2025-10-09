extends TileMapLayer

@export var draw_size := Vector2i(50, 50)
var noise_scale = 0.008
var draw_seed := 1565165
var draw_value: Vector2

func _ready() -> void:
	create_noise()

func create_noise() -> void:
	draw_seed = randi()
	draw_value = Vector2(randf_range(0.46, 0.48), randf_range(0.52, 0.56))
	clear()
	
	var noise := FastNoiseLite.new()
	noise.seed = draw_seed
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = noise_scale
	
	for x in draw_size.x:
		for y in draw_size.y:
			var noise_value = noise.get_noise_2d(x, y)
			noise_value = (noise_value + 1) / 2
			
			if draw_value.x < noise_value and noise_value < draw_value.y:
				set_cell(Vector2i(x, y), 0, Vector2i(1, 0))
