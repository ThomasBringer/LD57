extends Node2D

@export var spawn_rect: ReferenceRect
const GRASS_BLADE = preload("res://grass/grass_blade.tscn")

@export var density100: float = 1.5

func _ready() -> void:
	var size: Vector2 = spawn_rect.size
	#var volume = size.x * size.y
	var number: Vector2i = Vector2i(
		roundi(density100 * size.x * .01),
		roundi(density100 * size.y * .01))
	var square_size: Vector2 = Vector2(
		size.x / number.x,
		size.y / number.y
	)
	for x in number.x:
		for y in number.y:
			var pos: Vector2 = Vector2(x, y) * square_size + spawn_rect.position
			var instance = GRASS_BLADE.instantiate()
			add_child(instance)
			instance.position = pos + square_size * .5 + 1.5 * square_size * Vector2(randf(), randf())
			instance.randomize_shader_param()
