extends Area2D

var saved_bodies: Array[Node2D] = []
@onready var audio_sword_swing: AudioStreamPlayer = $"../../../../AudioSwordSwing"
@onready var audio_shovel: AudioStreamPlayer = $"../../../../AudioShovel"

@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision.set_deferred("disabled", true)

func start_attack():
	saved_bodies.clear()
	already_played_shovel = false
	collision.set_deferred("disabled", false)

func end_attack():
	collision.set_deferred("disabled", true)

func _on_body_entered(body: Node2D) -> void:
	enter(body)

func _on_area_entered(area: Area2D) -> void:
	enter(area)

var already_played_shovel: bool = false

func enter(body: Node2D) -> void:
	if body in saved_bodies: return
	if not already_played_shovel:
		if "play_shovel_sound" in body and not body.play_shovel_sound:
			pass
		else:
			audio_shovel.play()
			already_played_shovel = true
			
	if saved_bodies.size() < 1:
		audio_sword_swing.play()
	saved_bodies.append(body)
	body.damage()
