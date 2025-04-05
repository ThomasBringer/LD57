extends Node2D

@export var speed_degrees: float = 180
var speed: float

@export var target: Node2D

@export var local: bool = true

var target_rot: float:
	get:
		return target.rotation if local else target.global_rotation
var target_rot_clamped: float:
	get:
		return fposmod(target_rot, TAU)

var rot: float:
	get:
		return rotation if local else global_rotation
	set(value):
		if local:
			rotation = value
		else:
			global_rotation = value
var rot_clamped: float:
	get:
		return fposmod(rot, TAU)

func _ready() -> void:
	if target:
		initialize()
	else:
		process_mode = ProcessMode.PROCESS_MODE_DISABLED

func initialize() -> void:
	enable_process_after_target()
	self.speed = deg_to_rad(self.speed_degrees)

func enable_process_after_target() -> void:
	process_mode = ProcessMode.PROCESS_MODE_INHERIT
	process_priority = target.process_priority + 1

func assign_target(target: Node2D, local: bool = self.local, speed_degrees: float = self.speed_degrees) -> void:
	self.target = target
	self.local = local
	self.speed_degrees = speed_degrees
	initialize()

func signed_angle() -> float:
	var dif: float = target_rot_clamped - rot_clamped
	var angle: float = abs(dif)
	var dir_sign: float
	var other_way: bool = angle > PI
	if other_way:
		angle = TAU - angle
	dir_sign = (-1 if other_way else 1) * sign(dif)
	return dir_sign * angle

func _process(delta: float) -> void:
	if 1 < speed * delta: # Prevents overshoot on lag spikes
		rot = target_rot
		return
	
	rot += signed_angle() * speed * delta
