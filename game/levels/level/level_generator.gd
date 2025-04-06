extends Node2D

@export var data: LevelGenData

@onready var collision_polygon_water_left: CollisionPolygon2D = $WaterLeft/CollisionPolygon2D
@onready var collision_polygon_water_right: CollisionPolygon2D = $WaterRight/CollisionPolygon2D

@onready var polygon_ground: Polygon2D = $PolygonGround
const BRIDGE_WIDTH: int = 600
const BRIDGE_DEPTH: int = 1000

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
	#collision_polygon_water_right.polygon = points_water_right
