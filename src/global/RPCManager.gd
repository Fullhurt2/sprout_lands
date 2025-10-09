extends Node

var players_count := 1

var players_list := {}

func add_new_player(node: CharacterBody2D) -> void:
	if players_list.has(node.get_multiplayer_authority()):
		return
	players_list[node.get_multiplayer_authority()] = {
		"skin": node.skin,
		"name": node.nickname,
		"node": node
	}
	players_count = players_list.size()

func remove_player(peer_id: int) -> void:
	if !players_list.has(peer_id):
		return
	players_list[peer_id]["node"].queue_free()
	players_list.erase(peer_id)
	players_count = players_list.size()

@rpc("unreliable", "any_peer")
func sync_state(property: String, value) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	if !players_list.has(sender_id):
		return
	var node: Node = players_list[sender_id]["node"]
	if !is_instance_valid(node):
		return
	node.set(property, value)
