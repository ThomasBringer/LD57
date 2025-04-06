extends Node2D

@onready var head_pivot: Node2D = $"../Points/Followers/Head/Scaler/HeadPivot"
@onready var nose: Line2D = $"../Visuals/Z/Nose"
const TOLERANCE: float = .1

func _ready() -> void:
	process_priority = head_pivot.process_priority + 1

func is_pointing_front(pivot: Node2D) -> bool:
	var dir = pivot.global_transform.x
	return dir.dot(Vector2.DOWN) >= -TOLERANCE

func order(pivot: Node2D, node: Node2D, z: int) -> void:
	node.z_index = z if is_pointing_front(pivot) else -z

func _process(delta: float) -> void:
	order(head_pivot, nose, 1)
