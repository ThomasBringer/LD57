extends Node2D

@onready var next_level_spawn: Node2D = $NextLevelSpawn

func get_next_spawn() -> Vector2:
	return next_level_spawn.global_position
