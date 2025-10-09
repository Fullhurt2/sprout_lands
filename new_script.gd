extends Node

func _on_timer_gun_shoot_timeout() -> void:
  rpc("shoot")

@rpc("call_local","any_peer", "reliable")
func shoot():
  var bullet
  $blockbench_export/Node.add_child(bullet)
  bullet.global_position = $"blockbench_export/Node/рука2Г/Marker3D".global_position
  bullet.top_level = true
