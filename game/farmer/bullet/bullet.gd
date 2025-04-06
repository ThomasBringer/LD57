class_name Bullet
extends Area2D

const SPEED: float = 1200
var dir: Vector2

static var bullets: Array[Bullet] = []

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
		game_over()
	explode()

func game_over() -> void:
	Levels.game_over()

static func enable_player_collision_all(val: bool) -> void:
	for b in bullets:
		if b and is_instance_valid(b):
			b.enable_player_collision(val)

func enable_player_collision(val: bool) -> void:
	set_collision_mask_value(1, val)

func _on_lifetime_timeout() -> void:
	explode()

static func clear_bullets() -> void:
	for f in bullets:
		if f and is_instance_valid(f):
			f.queue_free()
	bullets.clear()
