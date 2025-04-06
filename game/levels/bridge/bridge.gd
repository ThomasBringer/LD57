extends Node2D

@onready var door_collision: CollisionShape2D = $DoorBody/CollisionShape2D

func open_door() -> void:
	door_collision.set_deferred("disabled", true)
