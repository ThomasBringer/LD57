extends Node2D

@onready var door_collision: CollisionShape2D = $DoorBody/CollisionShape2D
@onready var next_level_spawn: Node2D = $NextLevelSpawn
@onready var close: Node2D = $Close
@onready var open: Node2D = $Open

func open_door() -> void:
	close.hide()
	open.show()
	door_collision.set_deferred("disabled", true)
