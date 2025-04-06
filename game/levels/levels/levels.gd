extends Node2D

const LEVEL1 = preload("res://levels/premade/level1.tscn")
const LEVEL = preload("res://levels/level/level.tscn")
const LEVEL_FINAL = preload("res://levels/premade/level1.tscn")

@export var datas: Array[LevelGenData]
var level_i: int = 0
var next_spawn: Vector2

func _ready() -> void:
	var level1 = LEVEL1.instantiate()
	add_child(level1)
	next_spawn = level1.get_next_spawn()
	spawn_level()

func try_spawn_level() -> void:
	if level_i < datas.size():
		spawn_level()
	else:
		var level_final = LEVEL_FINAL.instantiate()
		level_final.position = next_spawn
		add_child(level_final)

func spawn_level() -> void:
	var data: LevelGenData = datas[level_i]
	var level = LEVEL.instantiate()
	level.position = next_spawn
	add_child(level)
	level.gen(data)
	level_i += 1
	next_spawn = level.get_next_spawn()
