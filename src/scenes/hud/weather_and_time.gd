extends TextureRect

@onready var time_arrow: TextureRect = %"time arrow"
@onready var background_color: ColorRect = %"background color"
@onready var weather_icon: TextureRect = %"weather icon"

var weather_icons := preload("res://res/ui/hud/weather_and_time/weather_icons.png")

var colors := ["55588d", "d79e61", "8cbfc2", "d79e61", "55588d"]
var day_time := 5: # [0-4]
	set(value):
		if value != day_time:
			day_time = value
			change_background()

func _ready() -> void:
	Signals.day_passed.connect(_day_passed)
	background_color.color = Color(colors[int((time_arrow.rotation_degrees + 90.0) / 36)])

func _process(_delta: float) -> void:
	time_arrow.rotation_degrees = (TimeManager.time / (TimeManager.DAY_LENGTH / 180)) - 90
	day_time = clampi(floori((time_arrow.rotation_degrees + 90.0) / 36), 0, 4)


func change_background() -> void:
	var color_tween = create_tween()
	var icon_tween = create_tween()
	icon_tween.set_trans(Tween.TRANS_BACK)
	
	color_tween.tween_property(background_color, "color", Color(colors[day_time]), 1.0)
	
	icon_tween.tween_property(weather_icon, "position:y", 44, 0.5).set_ease(Tween.EASE_IN_OUT)
	icon_tween.tween_callback(get_weather_icon)
	icon_tween.tween_property(weather_icon, "position:y", 11, 0.5).set_ease(Tween.EASE_IN_OUT)


func get_weather_icon() -> void:
	var region := Rect2(TimeManager.day_type * 32, day_time * 32, 32, 32)
	var subtexture := AtlasTexture.new()
	subtexture.atlas = weather_icons
	subtexture.region = region
	weather_icon.texture = subtexture


func _day_passed() -> void:
	change_background()
