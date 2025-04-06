extends Node2D

#@export var sprites: Array[Sprite2D]
@onready var weapon_z: Node2D = $WeaponZ

const TOLERANCE: float = .1

func _ready() -> void:
	pass
	#process_priority = head_pivot.process_priority + 1

func is_pointing_front() -> bool:
	var dir = global_transform.x
	return dir.dot(Vector2.DOWN) >= -TOLERANCE

func is_pointing_right() -> bool:
	var dir = global_transform.x
	return dir.dot(Vector2.RIGHT) >= 0

func order() -> void:
	weapon_z.z_index = 155 if is_pointing_front() else 110

func flip() -> void:
	var right: bool = is_pointing_right()
	scale.y = 1 if right else -1
	#for sprite in sprites:
		#sprite.flip_v = not right

func _process(delta: float) -> void:
	flip()
	order()
