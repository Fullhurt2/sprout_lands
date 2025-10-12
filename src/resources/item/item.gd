extends Resource
class_name Item

const MAX_ITEM_COUNT = 20

@export var item_name := ""
@export var icon: Texture2D
@export_enum("Seed", "Idle", "Axe", "Hoe", "Water_can")
var type: String
var count := 0
@export var seed_name := ""
var is_stackable := type == "Seed"
