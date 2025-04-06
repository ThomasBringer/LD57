extends Area2D

var saved_bodies: Array[Node2D] = []
@onready var audio_sword_swing: AudioStreamPlayer = $"../../../../AudioSwordSwing"

@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision.set_deferred("disabled", true)

func start_attack():
	saved_bodies.clear()
	collision.set_deferred("disabled", false)

func end_attack():
	collision.set_deferred("disabled", true)

func _on_body_entered(body: Node2D) -> void:
	enter(body)

func _on_area_entered(area: Area2D) -> void:
	enter(area)

func enter(body: Node2D) -> void:
	if body in saved_bodies: return
	if saved_bodies.size() < 1:
		audio_sword_swing.play()
	saved_bodies.append(body)
	body.damage()
