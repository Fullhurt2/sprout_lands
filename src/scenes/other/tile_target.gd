extends AnimatedSprite2D

var tween: Tween

@export var is_down_side := false

func _ready() -> void:
	Signals.tile_target_changed.connect(_on_tile_target_changed)
	Signals.tile_target_start.connect(_on_tile_target_start)
	if is_down_side:
		offset.y = -16
	play("down" if is_down_side else "up")
	modulate.a = 0


func _on_tile_target_start(pos: Vector2) -> void:
	global_position = pos

func _on_tile_target_changed(pos: Vector2) -> void:
	if tween != null: tween.kill()
	if is_down_side: pos.y += 16
	tween = get_tree().create_tween()
	modulate.a = 1
	tween.tween_property(self, "global_position", pos, 0.1)
