extends Area2D

var saved_bodies: Array[Node2D] = []

@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision.set_deferred("disabled", true)

func start_attack():
	saved_bodies.clear()
	collision.set_deferred("disabled", false)

func end_attack():
	collision.set_deferred("disabled", true)

func _on_body_entered(body: Node2D) -> void:
	if body in saved_bodies: return
	saved_bodies.append(body)
	body.damage()
