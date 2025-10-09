extends Control

var axe := preload("res://src/resources/item/tools/axe.tres")
var hoe := preload("res://src/resources/item/tools/hoe.tres")
var water_can := preload("res://src/resources/item/tools/water_can.tres")

@onready var backpack_slots_container: GridContainer = %"backpack slots"
@onready var hotbar_slots_container: HBoxContainer = %"hotbar slots"
@onready var backpack: TextureRect = %"backpack window"
@onready var from_icon: TextureRect = %from_icon
@onready var to_icon: TextureRect = %to_icon

var move_items: Array[Dictionary]
var icon_offset := Vector2(5.0, 5.0)

var backpack_slots := {} #0 - 13
var hotbar_slots = {0: hoe, 1: axe, 2: water_can} #0 - 5

var is_backpack_open := false:
	set(value):
		button_group.allow_unpress = value
		is_backpack_open = value
		backpack.visible = value
		
		if value:     # Инвентарь открывается
			hotbar_slots_container.get_child(choosed_hotbar_slot).button_pressed = false
		else:         # Инвентарь закрывается
			hotbar_slots_container.get_child(choosed_hotbar_slot).button_pressed = true
			move_items.clear()

var choosed_hotbar_slot := Global.choosed_hotbar_slot:
	set(value):
		choosed_hotbar_slot = value
		Global.choosed_item = hotbar_slots_container.get_child(choosed_hotbar_slot).item
		Global.choosed_hotbar_slot = choosed_hotbar_slot

var button_group := ButtonGroup.new()

var from_tween: Tween
var to_tween: Tween


func _ready() -> void:
	Signals.inventory_button_pressed.connect(_on_inventory_button_pressed)
	
	for button in backpack_slots_container.get_children():
		button.button_group = button_group
	for button in hotbar_slots_container.get_children():
		button.button_group = button_group
	
	hotbar_slots_container.get_child(choosed_hotbar_slot).button_pressed = true
	check_up()


func check_up() -> void:
	for slot in backpack_slots:
		backpack_slots_container.get_child(slot).change_data(backpack_slots[slot])
	for slot in hotbar_slots:
		hotbar_slots_container.get_child(slot).change_data(hotbar_slots[slot])

func move_item(from_hotbar: bool, from_index: int, to_hotbar: bool, to_index: int) -> void:
	var from_item: Item = hotbar_slots_container.get_child(from_index).item if from_hotbar else backpack_slots_container.get_child(from_index).item
	var to_item: Item = hotbar_slots_container.get_child(to_index).item if to_hotbar else backpack_slots_container.get_child(to_index).item
	
	from_icon.texture = from_item.icon
	var from_pos = hotbar_slots_container.get_child(from_index).global_position + icon_offset if from_hotbar else backpack_slots_container.get_child(from_index).global_position + icon_offset
	from_icon.global_position = from_pos
	
	to_icon.texture = to_item.icon if to_item != null else to_icon.texture
	var to_pos = hotbar_slots_container.get_child(to_index).global_position + icon_offset if to_hotbar else backpack_slots_container.get_child(to_index).global_position + icon_offset
	to_icon.global_position = to_pos
	
	change_data(from_hotbar, from_index, null)
	change_data(to_hotbar, to_index, null)
	
	from_tween = get_tree().create_tween()
	to_tween = get_tree().create_tween()
	from_tween.tween_property(from_icon, "global_position", to_pos, 0.15)
	to_tween.tween_property(to_icon, "global_position", from_pos, 0.15)
	await from_tween.finished
	
	change_data(from_hotbar, from_index, to_item)
	change_data(to_hotbar, to_index, from_item)
	
	from_icon.texture = null
	to_icon.texture = null

func change_data(is_hotbar: bool, index: int, item: Item) -> void:
	if !is_hotbar:
		backpack_slots_container.get_child(index).change_data(item)
	else:
		hotbar_slots_container.get_child(index).change_data(item)


func _on_inventory_button_pressed(is_hotbar_button: bool, index: int) -> void:
	if is_hotbar_button and !is_backpack_open:
		choosed_hotbar_slot = index
	elif is_hotbar_button and is_backpack_open:
		if hotbar_slots_container.get_child(index).item if is_hotbar_button else backpack_slots_container.get_child(index).item == null:
			choosed_hotbar_slot = index
	
	if is_backpack_open:
		if move_items.size() == 0:
			var item: Item
			if !is_hotbar_button:
				item = backpack_slots_container.get_child(index).item
				if item == null:
					backpack_slots_container.get_child(index).button_pressed = false
					return
			else:
				item = hotbar_slots_container.get_child(index).item
				if item == null:
					hotbar_slots_container.get_child(index).button_pressed = false
					return
		move_items.append({is_hotbar_button: index})
		if move_items.size() == 2:
			move_item(move_items[0].keys()[0], move_items[0][move_items[0].keys()[0]], move_items[1].keys()[0], move_items[1][move_items[1].keys()[0]])
			
			if move_items[1].keys()[0]:
				hotbar_slots_container.get_child(move_items[1][move_items[1].keys()[0]]).button_pressed = false
			else:
				backpack_slots_container.get_child(move_items[1][move_items[1].keys()[0]]).button_pressed = false
			
			move_items.clear()

func _on_open_inventory_button_pressed() -> void:
	is_backpack_open = !is_backpack_open


func _on_ready() -> void:
	choosed_hotbar_slot = Global.choosed_hotbar_slot
