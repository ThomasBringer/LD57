extends Node2D

@export var data: LevelGenData

@onready var base: Node2D = $Base
@onready var collision_polygon_water_left: CollisionPolygon2D = $Base/WaterLeft/CollisionPolygon2D
@onready var collision_polygon_water_right: CollisionPolygon2D = $Base/WaterRight/CollisionPolygon2D

@onready var polygon_ground: Polygon2D = $Base/PolygonGround
const BRIDGE_WIDTH: int = 1500
const BRIDGE_DEPTH: int = 2000
const BRIDGE = preload("res://levels/bridge/bridge.tscn")

func _ready() -> void:
	gen()

func gen() -> void:
	var points_visual: Array[Vector2] = []
	var points_water_left: Array[Vector2] = []
	var points_water_right: Array[Vector2] = []
	var angle_step = PI / data.semi_sides
	var side_length: float = data.map_size * sin(.5 * PI / data.semi_sides)
	var start_angle = PI / 2 + angle_step / 2
	
	for i in 2 * data.semi_sides:
		
		var angle = start_angle + angle_step * i
		var point = Vector2(cos(angle), sin(angle)) * .5 * data.map_size
		if i == 0:
			point.x = - BRIDGE_WIDTH * .5
			points_visual.append(point)
			points_water_left.append(point)
		elif i == data.semi_sides - 1:
			point.x = - BRIDGE_WIDTH * .5
			points_visual.append(point)
			points_water_left.append(point)
			var point2 = point + BRIDGE_DEPTH * Vector2.UP
			points_water_left.append(point2)
			var point3 = point2 + data.map_size * Vector2.LEFT
			points_water_left.append(point3)
			var point4 = Vector2(point3.x, points_visual[0].y)
			points_water_left.append(point4)
		elif i == data.semi_sides:
			point.x = BRIDGE_WIDTH * .5
			points_visual.append(point)
			points_water_right.append(point)
		elif i == 2 * data.semi_sides - 1:
			point.x = BRIDGE_WIDTH * .5
			points_visual.append(point)
			points_water_right.append(point)
			var point2 = Vector2(data.map_size, point.y)
			points_water_right.append(point2)
			var point3 = Vector2(point2.x, points_water_right[0].y - BRIDGE_DEPTH)
			points_water_right.append(point3)
			var point4 = Vector2(points_water_right[0].x, point3.y)
			points_water_right.append(point4)
		else:
			var rand_angle = TAU * randf()
			var rand_distance = side_length * .4 * randf()
			var rand_vector = rand_distance * Vector2.DOWN.rotated(rand_angle)
			point += rand_vector
			points_visual.append(point)
			if i <= data.semi_sides - 1:
				points_water_left.append(point)
			else:
				points_water_right.append(point)
	
	polygon_ground.polygon = points_visual
	collision_polygon_water_left.polygon = points_water_left
	collision_polygon_water_right.polygon = points_water_right
	base.position.y = - points_visual[0].y
	
	var bridge = BRIDGE.instantiate()
	bridge.position.x = 0
	bridge.position.y = points_water_right[0].y - points_visual[0].y - BRIDGE_DEPTH * .5
	add_child(bridge)
