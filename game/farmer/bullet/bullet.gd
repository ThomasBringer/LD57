class_name Bullet
extends Area2D

const SPEED: float = 1200
var dir: Vector2

static var bullets: Array[Bullet] = []
@onready var audio_explosion: AudioStreamPlayer = $AudioExplosion
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	bullets.append(self)

func _process(delta: float) -> void:
	if dir:
		rotation = dir.angle()
		position += SPEED * delta * dir

func explode() -> void:
	queue_free()

func damage() -> void:
	explode()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mole"):
		body.get_node("Move").damage()
		audio_explosion.play()
		hide()
		collision_shape_2d.set_deferred("disabled", true)
		await get_tree().create_timer(2.).timeout
		explode()
	else:
		explode()

#func game_over() -> void:
	#Levels.game_over()

static func enable_player_collision_all(val: bool) -> void:
	for b in bullets:
		if b and is_instance_valid(b):
			b.enable_player_collision(val)

func enable_player_collision(val: bool) -> void:
	set_collision_mask_value(1, val)

func _on_lifetime_timeout() -> void:
	queue_free()

static func clear_bullets() -> void:
	for f in bullets:
		if f and is_instance_valid(f):
			f.queue_free()
	bullets.clear()
