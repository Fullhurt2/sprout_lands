extends ParallaxBackground

@export var scroll_speed := 15.0 

func _ready() -> void:
	Signals.change_scene.connect(_on_scene_changing)
	scroll_offset = Global.parallax_scroll_offset

func _physics_process(delta: float) -> void:
	scroll_offset.x -= scroll_speed * delta
	scroll_offset.y -= scroll_speed * delta


func _on_scene_changing() -> void:
	Global.parallax_scroll_offset = scroll_offset
