extends Resource
class_name Item

@export var item_name := ""
@export var icon: Texture2D
@export_enum("Seed", "Idle", "Axe", "Hoe", "Water_can")
var type: String
var count := 0
@export var seed_name := ""
