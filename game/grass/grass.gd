extends Area2D

const TARGET_SKEW: float = 40
const SKEW_SPEED: float = 5
@onready var skewer: Node2D = $Skewer

func _process(delta: float) -> void:
	var bodies: Array[Node2D] = get_overlapping_bodies()
	var target_skew = 0
	if bodies:
		var closest_body: Node2D = null
		var closest_distance: float = INF
		for body in bodies:
			var distance = abs(body.global_position.x - global_position.x)
			if distance < closest_distance:
				closest_distance = distance
				closest_body = body
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
