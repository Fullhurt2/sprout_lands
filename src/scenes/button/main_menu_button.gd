extends TextureButton

@onready var label: Label = $Label

func _on_button_down() -> void:
	label.position.y += 2

func _on_button_up() -> void:
	label.position.y -= 2
