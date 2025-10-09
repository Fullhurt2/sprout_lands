extends TextureButton

@onready var icon_texture: TextureRect = $icon
@onready var count_label: Label = $"count label"

@export var is_hotbar_button := false

var item: Item


func change_data(new_item: Item) -> void:
	if new_item != null:
		item = new_item
		icon_texture.texture = new_item.icon
		count_label.text = str(new_item.count) if new_item.count > 0 else ""
	else:
		item = null
		icon_texture.texture = null
		count_label.text = ""


func _on_pressed() -> void:
	Signals.inventory_button_pressed.emit(is_hotbar_button, get_index())
