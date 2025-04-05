extends Node2D

@export var speed: float = 100

@export var target: Node2D

@export var local: bool = true

var target_pos: Vector2:
	get:
		return target.position if local else target.global_position

var pos: Vector2:
	get:
		return position if local else global_position
	set(value):
		if local:
			position = value
		else:
			global_position = value

func _ready() -> void:
	if target:
		enable_process_after_target()
	else:
		process_mode = ProcessMode.PROCESS_MODE_DISABLED

func enable_process_after_target() -> void:
	process_mode = ProcessMode.PROCESS_MODE_INHERIT
	process_priority = target.process_priority + 1

func assign_target(target: Node2D, local: bool = self.local, speed: float = self.speed) -> void:
	self.target = target
	self.local = local
	self.speed = speed
	enable_process_after_target()

func _process(delta: float) -> void:
	if 1 < speed * delta: # Prevents overshoot on lag spikes
		pos = target_pos
		return
		
	pos += (target_pos - pos) * speed * delta
