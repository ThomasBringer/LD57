extends Node2D

@onready var head_pivot: Node2D = $"../Points/Followers/Head/Scaler/HeadPivot"
@onready var nose: Line2D = $"../Visuals/Nose"
const TOLERANCE: float = .1

func _ready() -> void:
	process_priority = head_pivot.process_priority + 1

func _process(delta: float) -> void:
	var dir = head_pivot.transform.x
	var is_front: bool = dir.dot(Vector2.DOWN) >= -TOLERANCE
	nose.z_index = 5 if is_front else -5
