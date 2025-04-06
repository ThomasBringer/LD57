extends Node2D

#@export var sprites: Array[Sprite2D]
@onready var weapon_z: Node2D = $WeaponZ
const TOLERANCE: float = .1

const BULLET = preload("res://farmer/bullet/Bullet.tscn")

@export var number_bullet_per_shot: int = 3
@export var spread_degrees: float = 30
@onready var bullet_spawn: Node2D = $"../BulletSpawn"
@onready var audio_gun: AudioStreamPlayer = $"../../../AudioGun"

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

func shoot():
	audio_gun.play()
	var dir = global_transform.x
	dir = dir.rotated(deg_to_rad(- spread_degrees * (number_bullet_per_shot - 1) * .5))
	for i in number_bullet_per_shot:
		shoot_one_bullet(dir)
		dir = dir.rotated(deg_to_rad(spread_degrees))

func shoot_one_bullet(dir: Vector2) -> void:
	var instance = BULLET.instantiate()
	instance.dir = dir
	instance.position = bullet_spawn.global_position
	get_tree().root.add_child(instance)	
