extends Node2D

@onready var anim: AnimationPlayer = $Anim

func play() -> void:
	anim.play("on")
