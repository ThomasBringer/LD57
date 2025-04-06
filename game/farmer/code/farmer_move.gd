class_name FarmerMove
extends Node2D

@onready var farmer: CharacterBody2D = owner

@export var pivot_targets: Array[Node2D]
@onready var offset_head: Node2D = $"../Points/Scaler/PivotTarget/OffsetHead"
@onready var head: Node2D = $"../Points/Followers/Head"
@onready var mole: CharacterBody2D = get_tree().get_first_node_in_group("mole")

signal start_move(start: bool)

static var farmers: Array[FarmerMove] = []

var speed: float
const SLOW_SPEED: float = 250
const SPEED: float = 400
const RUN_SPEED: float = 800
const DIST_TO_MOLE_SIGHT = 1000
const DIST_TO_MOLE_TARGET = 750
const DIST_TO_MOLE_MIN = 500

func _ready() -> void:
	farmers.append(self)

var moving: bool = false
func set_moving(is_moving: bool) -> void:
	offset_head.position.x = 25 if is_moving else 0
	head.position.y = -50
	if is_moving != moving:
		moving = is_moving
		start_move.emit(is_moving)

func brain() -> Vector2:
	if not mole:
		mole = get_tree().get_first_node_in_group("mole")
	var diff: Vector2 = (mole.position - farmer.position)
	var diff_norm: Vector2 = diff.normalized()
	var dist = diff.length()
	var input: Vector2 = Vector2.ZERO
	if DIST_TO_MOLE_SIGHT < dist:
		pass
	elif DIST_TO_MOLE_TARGET < dist:
		speed = SPEED
		input = diff_norm * SPEED
		face(diff)
	elif DIST_TO_MOLE_MIN < dist:
		speed = SLOW_SPEED
		input = diff_norm.orthogonal() * SLOW_SPEED
		face(diff)
	else:
		speed = SPEED
		input = -diff_norm * SPEED
		face(diff)
	return input

func face(dir: Vector2) -> void:
	for pivot in pivot_targets:
		pivot.rotation = dir.angle()
		
func _process(delta: float) -> void:
	var input = brain()
	set_moving(input.length_squared())
	#if input:
		#if input.length_squared() > 1:
			#input = input.normalized()
	#if not input: return
	#if input:
		#for pivot in pivot_targets:
			#pivot.rotation = input.angle()
	farmer.velocity = input
	farmer.move_and_slide()

static func enable_player_collision_all(val: bool) -> void:
	for f in farmers:
		if f and is_instance_valid(f):
			f.enable_player_collision(val)

func enable_player_collision(val: bool) -> void:
	farmer.set_collision_mask_value(1, val)
