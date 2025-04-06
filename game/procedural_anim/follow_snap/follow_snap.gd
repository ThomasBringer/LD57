extends Node2D

@export var node: Node2D

func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_INHERIT
	process_priority = 1 + node.process_priority

func _process(delta: float) -> void:
	global_position = node.global_position
