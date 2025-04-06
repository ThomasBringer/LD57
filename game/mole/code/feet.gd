extends Node2D

@onready var pivot: Node2D = $"../Points/Scaler/Pivot"

@onready var foot_12: Node2D = $"../Points/RemoteFeet/Foot1Upper/Foot11/Foot12"
@onready var foot_13: Node2D = $"../Points/RemoteFeet/Foot1Upper/Foot11/Foot12/Foot13"

@onready var foot_22: Node2D = $"../Points/RemoteFeet/Foot2Upper/Foot21/Foot22"
@onready var foot_23: Node2D = $"../Points/RemoteFeet/Foot2Upper/Foot21/Foot22/Foot23"

@onready var rest_timer: Timer = $RestTimer

const LOOP_TIME: float =  .5
const STEP_DISTANCE: float = 25

var loop_pulsation: float
var time: float = 0.

var is_moving: bool = false
var foot_sine: float = 0.
var end_foot_sine: float = 0.

@onready var audio_steps: AudioStreamPlayer = $"../AudioSteps"
@onready var audio_step_timer: Timer = $AudioStepTimer

func _ready() -> void:
	process_mode = pivot.process_mode + 1
	loop_pulsation = TAU / LOOP_TIME

func _process(delta: float) -> void:
	time += delta
	foot_12.global_rotation = pivot.global_rotation
	foot_22.global_rotation = pivot.global_rotation
	
	var offset: float
	if is_moving:
		foot_sine = sin(loop_pulsation * time)
		offset = foot_sine
	else:
		var t: float = rest_timer.time_left / rest_timer.wait_time
		offset = lerpf(0, end_foot_sine, t)
		
	foot_13.position.x = STEP_DISTANCE * offset
	foot_23.position.x = - STEP_DISTANCE * offset
	
func _on_mole_movement_start_move(start: bool) -> void:
	is_moving = start
	if start:
		time = 0.
		audio_step_timer.start()
		audio_steps.play()
	else:
		audio_step_timer.stop()
		end_foot_sine = foot_sine
		rest_timer.start()

func _on_audio_step_timer_timeout() -> void:
	audio_steps.play()
