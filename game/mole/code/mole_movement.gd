extends Node2D

const SPEED: float = 1000

@onready var mole: CharacterBody2D = owner
@onready var pivot_target: Node2D = $"../Points/Scaler/PivotTarget"
@onready var offset_head: Node2D = $"../Points/Scaler/PivotTarget/OffsetHead"

func set_moving(is_moving: bool) -> void:
	offset_head.position.x = 25 if is_moving else 0

func _process(delta: float) -> void:
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	set_moving(input.length_squared())
	if not input: return
	pivot_target.rotation = input.angle()
	if input.length_squared() > 1:
		input = input.normalized()
	mole.velocity = input * SPEED
	mole.move_and_slide()
