extends CanvasLayer


func _on_fall_asleep_pressed() -> void:
	Signals.fell_asleep.emit()
