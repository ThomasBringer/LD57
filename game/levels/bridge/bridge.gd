extends Node2D

@onready var door_collision: CollisionShape2D = $DoorBody/CollisionShape2D
@onready var next_level_spawn: Node2D = $NextLevelSpawn

func open_door() -> void:
	door_collision.set_deferred("disabled", true)
