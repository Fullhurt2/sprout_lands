class_name State
extends Node

var parent: Player

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null

#func process_input(event: InputEvent) -> State:
	#return null
