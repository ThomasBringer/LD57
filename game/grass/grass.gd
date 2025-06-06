extends Area2D

const TARGET_SKEW: float = 40
const SKEW_SPEED: float = 5
@onready var skewer: Node2D = $Skewer
@onready var sprite: Sprite2D = $Skewer/Sprite
#@onready var audio_sword_swing: AudioStreamPlayer = $AudioSwordSwing
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var destroy_timer: Timer = $DestroyTimer
@onready var particles: GPUParticles2D = $ParticlesGrass/GPUParticles2D

var play_shovel_sound: bool = false

func check_area_bridge() -> void:
	var areas: Array[Area2D] = get_overlapping_areas()
	for area in areas:
		if area.is_in_group("bridge"):
			queue_free()

func _ready() -> void:
	if randi_range(0, 1):
		sprite.flip_h = true
	check_area_bridge()
	var bodies: Array[Node2D] = get_overlapping_bodies()
	for body in bodies:
		if not body.is_in_group("character"):
			queue_free()

func _process(delta: float) -> void:
	check_area_bridge()
	var bodies: Array[Node2D] = get_overlapping_bodies()
	var target_skew = 0
	if bodies:
		var closest_body: Node2D = null
		var closest_distance: float = INF
		for body in bodies:
			if body.is_in_group("character"):
				var distance = abs(body.global_position.x - global_position.x)
				if distance < closest_distance:
					closest_distance = distance
					closest_body = body
			else:
				queue_free()
				return
		target_skew = deg_to_rad(TARGET_SKEW if closest_body.global_position.x < global_position.x else - TARGET_SKEW)
	reach_skew(target_skew, delta)

func reach_skew(target_skew: float, delta: float) -> void:
	#skew = target_skew
	var ds: float = SKEW_SPEED * delta
	var diff: float = target_skew - skewer.skew
	var ds_signed: float = ds * sign(diff)
	if diff >= 0 and skewer.skew + ds_signed >= target_skew:
		skewer.skew = target_skew
	elif diff < 0 and skewer.skew + ds_signed <= target_skew:
		skewer.skew = target_skew
	else:
		skewer.skew += ds_signed

func randomize_shader_param() -> void:
	skewer.scale.x = .5 * (1 + randf())
	skewer.scale.y = .5 * (1 + randf())
	#sprite.self_modulate = ['#3e8948', '#265c42'].pick_random()
	var mat = sprite.material
	if mat is ShaderMaterial:
		mat.set_shader_parameter("speed", .5 + 1.5 * randf())
		mat.set_shader_parameter("dist", 15 + 10 * randf())

func damage() -> void:
	cut()

func cut() -> void:
	particles.restart()
	skewer.hide()
	collision_shape_2d.set_deferred("disabled", true)
	destroy_timer.start()

func annihilate() -> void:
	cut()

func _on_body_entered(body: Node2D) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("underground"):
		annihilate()

func _on_destroy_timer_timeout() -> void:
	queue_free()
