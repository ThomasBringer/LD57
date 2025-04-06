extends Node2D

const SPEED: float = 1000
const SPEED_UNDERGROUND: float = 1500

var speed: float = SPEED
@onready var mole: CharacterBody2D = owner
@onready var z: Node2D = $"../Visuals/Z"
@onready var attack: Node2D = $"../Attack"

@export var pivot_targets: Array[Node2D]
@onready var offset_head: Node2D = $"../Points/Scaler/PivotTarget/OffsetHead"
@onready var head: Node2D = $"../Points/Followers/Head"

@export var graphics: Array[CanvasItem]
var color_dict = {}

signal start_move(start: bool)

const UNDERGROUND_COLOR: Color = '#3e2731'
@onready var collision_shape_2d: CollisionShape2D = $"../CollisionShape2D"

var is_underground: bool = false
@onready var tunnel_particles: GPUParticles2D = $"../TunnelParticles"
const TUNNEL_FORWARD: float = 50

@onready var area_wall_checker: Area2D = $"../AreaWallChecker"
var trying_aboveground: bool = false
#@onready var area_destroy_grass: Area2D = $"../AreaDestroyGrass"
@onready var area_destroy_grass_collsion: CollisionShape2D = $"../AreaDestroyGrass/CollisionShape2D"
@onready var audio_go_underground: AudioStreamPlayer = $"../AudioGoUnderground"
@onready var audio_digging: AudioStreamPlayer = $"../AudioDigging"

var last_nonzero_input: Vector2 = Vector2.RIGHT

var moving: bool = false
func set_moving(is_moving: bool) -> void:
	offset_head.position.x = (75 if is_underground else 25) if is_moving else 0
	head.position.y = -25 if is_underground else -50
	if is_moving != moving:
		moving = is_moving
		start_move.emit(is_moving)
		#if is_moving:
			#if is_underground:
				#tunnel_particles.emitting = true
		#else:
			#tunnel_particles.emitting = false

func _ready() -> void:
	area_destroy_grass_collsion.set_deferred("disabled", true)
	for graphic in graphics:
		color_dict[graphic] = graphic.self_modulate

func _process(delta: float) -> void:
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	set_moving(input.length_squared())
	if input:
		if input.length_squared() > 1:
			input = input.normalized()
		last_nonzero_input = input
	if not is_underground and not input: return
	if is_underground:
		last_nonzero_input = last_nonzero_input.normalized()
	for pivot in pivot_targets:
		pivot.rotation = last_nonzero_input.angle()
	tunnel_particles.position = TUNNEL_FORWARD * last_nonzero_input
	mole.velocity = last_nonzero_input * speed
	mole.move_and_slide()

func recolor_default() -> void:
	for graphic in graphics:
		graphic.self_modulate = color_dict[graphic]

func recolor(color: Color) -> void:
	for graphic in graphics:
		graphic.self_modulate = color

func recolor_underground() -> void:
	recolor(UNDERGROUND_COLOR)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dig"):
		go_underground()
	elif event.is_action_released("dig"):
		try_go_aboveground()

func go_underground() -> void:
	audio_digging.play()
	audio_go_underground.play()
	trying_aboveground = false
	z.z_index = -10
	attack.z_index = -200
	mole.set_collision_mask_value(2, false)
	recolor_underground()
	speed = SPEED_UNDERGROUND
	is_underground = true
	#if moving:
	tunnel_particles.emitting = true
	area_destroy_grass_collsion.set_deferred("disabled", false)

func try_go_aboveground() -> void:
	trying_aboveground = true
	while area_wall_checker.has_overlapping_bodies() && trying_aboveground:
		await get_tree().process_frame
	if trying_aboveground:
		go_aboveground()

func go_aboveground() -> void:
	audio_digging.stop()
	audio_go_underground.play()
	area_destroy_grass_collsion.set_deferred("disabled", true)
	trying_aboveground = false
	z.z_index = 150
	attack.z_index = 0
	mole.set_collision_mask_value(2, true)
	tunnel_particles.emitting = false
	recolor_default()
	speed = SPEED
	is_underground = false
