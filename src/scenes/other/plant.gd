extends Node2D

@onready var sprite: Sprite2D = $sprite


var plant_name := ""
var current_stage := 0


func _ready() -> void:
	Signals.day_passed.connect(_on_day_passed)
	sprite.texture = SpriteLoader.get_plant_icon(plant_name)
	change_stage(current_stage)


func change_stage(stage: int) -> void:
	current_stage = stage
	sprite.frame = current_stage
	if multiplayer.is_server():
		Global.plants_array[Vector2i(global_position)]["stage"] = current_stage


func _on_day_passed() -> void:
	change_stage(clamp(current_stage + 1, 0, 3))
