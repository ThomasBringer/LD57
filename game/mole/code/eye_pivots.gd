extends Node2D

@onready var head_pivot: Node2D = $"../Points/Followers/Head/Scaler/HeadPivot"

@onready var eye1_pivot: Node2D = $"../Points/Followers/Head/Scaler/Eye1BasePivot"
@onready var eye2_pivot: Node2D = $"../Points/Followers/Head/Scaler/Eye2BasePivot"

@onready var eye1: Sprite2D = $"../Visuals/Z/CircleHeadMask/Eye1Visual"
@onready var eye2: Sprite2D = $"../Visuals/Z/CircleHeadMask/Eye2Visual"

@onready var circle_head_mask: Sprite2D = $"../Visuals/Z/CircleHeadMask"

const SPREAD_DEGREES: float = 35
const TOLERANCE: float = .1

func _ready() -> void:
	process_priority = head_pivot.process_priority + 1

func norm_angle(angle_degrees: float) -> float:
	return (fposmod(angle_degrees + 180., 360.) - 180.)

func _process(delta: float) -> void:
	var angle: float = norm_angle(head_pivot.rotation_degrees)	
	var mid_angle: float = (
		lerp(SPREAD_DEGREES, 180. - SPREAD_DEGREES, angle / 180.)
		if angle >= 0
		else lerp(SPREAD_DEGREES, - 180 - SPREAD_DEGREES, - angle / 180.)
	)
	var front: bool = -sin(deg_to_rad(norm_angle(mid_angle))) <= TOLERANCE
	circle_head_mask.visible = front
	apply_angle(eye1_pivot, mid_angle - SPREAD_DEGREES, eye1)
	apply_angle(eye2_pivot, mid_angle + SPREAD_DEGREES, eye2)

func is_pointing_front(pivot: Node2D) -> bool:
	var dir = pivot.global_transform.x
	return dir.dot(Vector2.DOWN) >= -TOLERANCE

#func order(pivot: Node2D, node: Node2D, z: int) -> void:
	#node.z_index = z if is_pointing_front(pivot) else -z
#
func apply_angle(eye_pivot: Node2D, angle: float, eye: Node2D) -> void:
	eye_pivot.rotation_degrees = angle
	#order(eye_pivot, eye, 15)
