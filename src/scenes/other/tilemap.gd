extends Node2D

@onready var water: TileMapLayer = $water
@onready var grass: TileMapLayer = $grass
@onready var dirt: TileMapLayer = $dirt
@onready var hills: TileMapLayer = $hills

var neighbor_offsets := [Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1), Vector2i(-1,  0), Vector2i(1,  0), Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)]

func _ready() -> void:
	Signals.tilling_tile.connect(_tilling_tile)
	if !multiplayer.is_server():
		rpc_id(1, "serialize_tilemap", multiplayer.get_unique_id())


func _tilling_tile(pos: Vector2i) -> void:
	rpc_id(1, "tilling_logic", pos)

@rpc("any_peer", "call_local")
func tilling_logic(pos: Vector2i) -> void:
	for offset in neighbor_offsets:
		if !grass.get_cell_tile_data(pos + offset):
			return
	
	if !dirt.get_cell_tile_data(pos):
		rpc("terrain_connect", "dirt", [pos], 0, 2)
	else:
		rpc("erase_tile", "dirt", pos)
		for offset in neighbor_offsets:
			var offset_pos = pos + offset
			if dirt.get_cell_tile_data(offset_pos):
				rpc("erase_tile", "dirt", offset_pos)
				rpc("terrain_connect", "dirt", [offset_pos], 0, 2)

@rpc("call_local")
func erase_tile(tilemap_layer: String, pos: Vector2i) -> void:
	match tilemap_layer:
		"dirt":
			dirt.erase_cell(pos)

@rpc("call_local")
func terrain_connect(tilemap_layer: String, pos_array: Array, terrain_set: int, terrain: int) -> void:
	match tilemap_layer:
		"dirt":
			dirt.set_cells_terrain_connect(pos_array, terrain_set, terrain)


@rpc("any_peer")
func serialize_tilemap(peer_id: int) -> void:
	var data = []
	for cell in dirt.get_used_cells():
		data.append([
			cell,
			dirt.get_cell_source_id(cell),
			dirt.get_cell_atlas_coords(cell),
		])
	rpc_id(peer_id, "deserialize_tilemap", data)

@rpc("any_peer")
func deserialize_tilemap(data: Array) -> void:
	dirt.clear()
	for entry in data:
		dirt.set_cell(entry[0], entry[1], entry[2])
