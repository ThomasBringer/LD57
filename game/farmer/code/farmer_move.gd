class_name FarmerMove
extends Node2D

@onready var farmer: CharacterBody2D = owner

@export var pivot_targets: Array[Node2D]
@onready var offset_head: Node2D = $"../Points/Scaler/PivotTarget/OffsetHead"
@onready var head: Node2D = $"../Points/Followers/Head"
@onready var mole: CharacterBody2D = get_tree().get_first_node_in_group("mole")
@onready var mole_move: Node2D = get_tree().get_first_node_in_group("mole").get_node("Move")

signal start_move(start: bool)

static var farmers: Array[FarmerMove] = []

var last_speed: float = 0.
var speed: float = 0.
var actual_speed: float = 0.
var input: Vector2 = Vector2.ZERO
const SLOW_SPEED: float = 250
const SPEED: float = 400
const BACK_SPEED: float = 600
const RUN_SPEED: float = 1000
const DIST_TO_MOLE_SIGHT = 1500
const DIST_TO_MOLE_TARGET = 850
const DIST_TO_MOLE_MIN = 650

var moving_sideways: bool = false
var sideways_direction: int = 1
@onready var switch_timer: Timer = $"../SwitchDirection"

@onready var shoot_timer: Timer = $"../ShootTimer"
var ready_to_shoot: bool = false
@onready var gun: Node2D = $"../Attack/AttackPivot/Gun"
@onready var z: Node2D = $"../Visuals/Z"

func _ready() -> void:
	randomize_shooter_time()
	farmers.append(self)

var moving: bool = false
func set_moving(is_moving: bool) -> void:
	#offset_head.position.x = 25 if is_moving else 0
	#head.position.y = -50
	if is_moving != moving:
		moving = is_moving
		start_move.emit(is_moving)

func brain() -> void:
	if not mole:
		mole = get_tree().get_first_node_in_group("mole")
	if not mole_move:
		mole_move = mole.get_node("Move")
	
	var diff: Vector2 = (mole.global_position - farmer.global_position)
	var diff_norm: Vector2 = diff.normalized()
	var dist = diff.length()

	if mole_move.is_underground:
		bend_head_vert(0)
		ready_to_shoot = false
		speed = 0
		input = Vector2.ZERO
		bend_head(0)
		moving_sideways = false
		#moving_sideways = false
		#ready_to_shoot = false
		#if DIST_TO_MOLE_SIGHT < dist:
			#speed = 0
			#input = Vector2.ZERO
			#bend_head_vert(0)
			#bend_head(0)
		#else:
			#speed = RUN_SPEED
			#input = -diff_norm
			#face(-diff)
			#bend_head_vert(15)
			#bend_head(50)
	else:
		bend_head_vert(0)
		if DIST_TO_MOLE_SIGHT < dist:
			ready_to_shoot = false
			speed = 0
			input = Vector2.ZERO
			bend_head(0)
			moving_sideways = false
		elif DIST_TO_MOLE_TARGET < dist:
			if not ready_to_shoot and shoot_timer.is_stopped():
				shoot_timer.start()
			ready_to_shoot = true
			speed = SPEED
			input = diff_norm
			face(diff)
			bend_head(25)
			moving_sideways = false
		elif DIST_TO_MOLE_MIN < dist:
			if not ready_to_shoot and shoot_timer.is_stopped():
				shoot_timer.start()
			ready_to_shoot = true
			if not moving_sideways and switch_timer.is_stopped():
				sideways_direction = 2 * randi_range(0, 1) - 1
				start_switch_timer()
			speed = SLOW_SPEED
			input = sideways_direction * diff_norm.orthogonal()
			face(diff)
			bend_head(0)
			moving_sideways = true
		else:
			if not ready_to_shoot and shoot_timer.is_stopped():
				shoot_timer.start()
			ready_to_shoot = true
			speed = BACK_SPEED
			input = -diff_norm
			face(diff)
			bend_head(-25)
			moving_sideways = false

func start_switch_timer() -> void:
	switch_timer.wait_time = 1. + 4. * randf()
	switch_timer.start()

func bend_head(x: float) -> void:
	offset_head.position.x = x

func bend_head_vert(y: float) -> void:
	head.position.y = y - 50

func face(dir: Vector2) -> void:
	for pivot in pivot_targets:
		pivot.rotation = dir.angle()
		
func _process(delta: float) -> void:
	if dead:
		return
	brain()
	set_moving(input.length_squared())
	
	var xx: float = delta * .75
	var blend: float = 1. - pow(.5, xx)
	actual_speed = lerp(last_speed, speed, blend)
	
	last_speed = actual_speed
	farmer.velocity = input * actual_speed
	farmer.move_and_slide()

static func clear_enemies() -> void:
	for f in farmers:
		if f and is_instance_valid(f):
			f.queue_free()
	farmers.clear()

static func enable_player_collision_all(val: bool) -> void:
	for f in farmers:
		if f and is_instance_valid(f):
			f.enable_player_collision(val)

func enable_player_collision(val: bool) -> void:
	farmer.set_collision_mask_value(1, val)

func _on_switch_direction_timeout() -> void:
	if not moving_sideways: return
	sideways_direction = - sideways_direction
	start_switch_timer()

func _on_shoot_timer_timeout() -> void:
	randomize_shooter_time()
	if ready_to_shoot:
		gun.shoot()
	else:
		shoot_timer.stop()

func randomize_shooter_time() -> void:
	shoot_timer.wait_time = 2. + 2.5 * randf()

var dead: bool = false

func _on_farmer_on_die() -> void:
	dead = true
	z.hide()
	Levels.enemy_die()
