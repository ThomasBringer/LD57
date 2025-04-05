extends Node2D

@onready var mole: CharacterBody2D = owner
const SPEED: float = 1000

func _process(delta: float) -> void:
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input.length_squared() > 1:
		input = input.normalized()
	mole.velocity = input * SPEED
	mole.move_and_slide()
