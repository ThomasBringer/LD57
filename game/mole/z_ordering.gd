extends Node2D

@onready var head_pivot: Node2D = $"../Points/Followers/Head/Scaler/HeadPivot"
@onready var nose: Line2D = $"../Visuals/Nose"
const TOLERANCE: float = .1

#@onready var eye1_pivot: Node2D = $"../Points/Followers/Head/Scaler/HeadPivot/Eye1BasePivot"
#@onready var eye2_pivot: Node2D = $"../Points/Followers/Head/Scaler/HeadPivot/Eye2BasePivot"
#
#@onready var eye1: Sprite2D = $"../Visuals/Eye1Visual"
#@onready var eye2: Sprite2D = $"../Visuals/Eye2Visual"

func _ready() -> void:
	process_priority = head_pivot.process_priority + 1

func is_pointing_front(pivot: Node2D) -> bool:
	var dir = pivot.global_transform.x
	return dir.dot(Vector2.DOWN) >= -TOLERANCE

func order(pivot: Node2D, node: Node2D, z: int) -> void:
	node.z_index = z if is_pointing_front(pivot) else -z

func _process(delta: float) -> void:
	#print(eye1_pivot.transform.x.dot(Vector2.DOWN))
	order(head_pivot, nose, 1)
	#order(eye1_pivot, eye1, 2)
	#order(eye2_pivot, eye2, 2)
