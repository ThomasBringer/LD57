class_name FarmerMove
extends Node2D

const SPEED: float = 500
@onready var farmer: CharacterBody2D = owner

@export var pivot_targets: Array[Node2D]
@onready var offset_head: Node2D = $"../Points/Scaler/PivotTarget/OffsetHead"
@onready var head: Node2D = $"../Points/Followers/Head"

signal start_move(start: bool)

static var farmers: Array[FarmerMove] = []

func _ready() -> void:
	farmers.append(self)

var moving: bool = false
func set_moving(is_moving: bool) -> void:
	offset_head.position.x = 25 if is_moving else 0
	head.position.y = -50
	if is_moving != moving:
		moving = is_moving
		start_move.emit(is_moving)

func _process(delta: float) -> void:
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	set_moving(input.length_squared())
	if input:
		if input.length_squared() > 1:
			input = input.normalized()
	if not input: return
	for pivot in pivot_targets:
		pivot.rotation = input.angle()
	farmer.velocity = input * SPEED
	farmer.move_and_slide()

static func enable_player_collision_all(val: bool) -> void:
	for f in farmers:
		f.enable_player_collision(val)

func enable_player_collision(val: bool) -> void:
	farmer.set_collision_mask_value(1, val)
