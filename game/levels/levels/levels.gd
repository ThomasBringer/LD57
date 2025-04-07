class_name Levels
extends Node2D

const LEVEL1 = preload("res://levels/premade/level1.tscn")
const LEVEL = preload("res://levels/level/level.tscn")
const LEVEL_FINAL = preload("res://levels/premade/level_final.tscn")

@export var datas: Array[LevelGenData]
var level_i: int = 0
var next_spawn: Vector2

var bridge

@onready var circle_frame: Node2D = $"../Mole/CircleFrame"

var spawned_levels: Array[Node2D]
var level1: Node2D

static var number_enemies: int = 0
static var main: Levels

func _ready() -> void:
	main = self
	level1 = LEVEL1.instantiate()
	add_child(level1)
	spawn_level2()

func spawn_level2() -> void:
	next_spawn = level1.get_next_spawn()
	spawn_level()

func try_spawn_level() -> void:
	if dead: return
	if level_i < datas.size():
		spawn_level()
	else:
		var level_final = LEVEL_FINAL.instantiate()
		level_final.position = next_spawn
		add_child(level_final)

func spawn_level() -> void:
	var data: LevelGenData = datas[level_i]
	number_enemies = data.num_enemies
	var level = LEVEL.instantiate()
	spawned_levels.append(level)
	level.position = next_spawn
	add_child(level)
	bridge = level.gen(data)
	level_i += 1
	next_spawn = level.get_next_spawn()

static func enemy_die() -> void:
	number_enemies -= 1
	if number_enemies <= 0:
		main.bridge.open_door()
		main.try_spawn_level()

static func game_over() -> void:
	main.game_over_()
	
@onready var cover: ColorRect = $"../Mole/Camera2D/Cover"
@onready var camera: Camera2D = $"../Mole/Camera2D"
var dead: bool = false

func game_over_() -> void:
	dead = true
	level_i = 0
	var mole = get_tree().get_first_node_in_group("mole")
	var mole_move = mole.get_node("Move")
	#mole_move.die()
	circle_frame.play()
	await get_tree().create_timer(3.1).timeout
	cover.show()
	camera.position_smoothing_enabled = false
	FarmerMove.clear_enemies()
	Bullet.clear_bullets()
	for level in spawned_levels:
		level.queue_free()
	spawned_levels.clear()
	mole.position = Vector2.ZERO
	mole_move.revive()
	dead = false
	level_i = 0
	spawn_level2()
	await get_tree().create_timer(.8).timeout
	camera.position_smoothing_enabled = true
	cover.hide()
	
