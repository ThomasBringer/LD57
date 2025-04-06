extends Node2D

#@export var data: LevelGenData

@onready var base: Node2D = $Base
@onready var collision_polygon_water_left: CollisionPolygon2D = $Base/WaterLeft/CollisionPolygon2D
@onready var collision_polygon_water_right: CollisionPolygon2D = $Base/WaterRight/CollisionPolygon2D
@onready var polygon_ground: Polygon2D = $Base/PolygonGround
@onready var edge_left: Line2D = $Base/EdgeLeft
@onready var edge_right: Line2D = $Base/EdgeRight

const BRIDGE_WIDTH: int = 1500
const BRIDGE_DEPTH: int = 2000
const BRIDGE = preload("res://levels/bridge/bridge.tscn")
const FARMER = preload("res://farmer/farmer.tscn")
var bridge: Node2D

const MIN_SQR_DIST_BTWN_ENEMIES: int = 40000
#func _ready() -> void:
	#gen()

func gen(data: LevelGenData) -> Node2D:
	base = $Base
	collision_polygon_water_left = $Base/WaterLeft/CollisionPolygon2D
	collision_polygon_water_right = $Base/WaterRight/CollisionPolygon2D
	polygon_ground = $Base/PolygonGround
	edge_left = $Base/EdgeLeft
	edge_right = $Base/EdgeRight
	
	edge_left.clear_points()
	edge_right.clear_points()
	edge_right.add_point(Vector2.ZERO)
	
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
			edge_left.add_point(point)
		elif i == data.semi_sides - 1:
			point.x = - BRIDGE_WIDTH * .5
			points_visual.append(point)
			points_water_left.append(point)
			edge_left.add_point(point)
			var point2 = point + BRIDGE_DEPTH * Vector2.UP
			points_water_left.append(point2)
			edge_left.add_point(point2)
			var point3 = point2 + 10000 * Vector2.LEFT
			points_water_left.append(point3)
			var point4 = Vector2(point3.x, points_visual[0].y)
			points_water_left.append(point4)
		elif i == data.semi_sides:
			point.x = BRIDGE_WIDTH * .5
			points_visual.append(point)
			points_water_right.append(point)
			edge_right.add_point(point)
		elif i == 2 * data.semi_sides - 1:
			point.x = BRIDGE_WIDTH * .5
			points_visual.append(point)
			points_water_right.append(point)
			edge_right.add_point(point)
			var point2 = Vector2(10000, point.y)
			points_water_right.append(point2)
			var point3 = Vector2(point2.x, points_water_right[0].y - BRIDGE_DEPTH)
			points_water_right.append(point3)
			var point4 = Vector2(points_water_right[0].x, point3.y)
			points_water_right.append(point4)
			edge_right.points[0] = point4
		else:
			var rand_angle = TAU * randf()
			var rand_distance = .75 * side_length * randf()
			var rand_vector = rand_distance * Vector2.DOWN.rotated(rand_angle)
			point += rand_vector
			points_visual.append(point)
			if i <= data.semi_sides - 1:
				edge_left.add_point(point)
				points_water_left.append(point)
			else:
				edge_right.add_point(point)
				points_water_right.append(point)
	
	polygon_ground.polygon = points_visual
	collision_polygon_water_left.polygon = points_water_left
	collision_polygon_water_right.polygon = points_water_right
	base.position.y = - points_visual[0].y
	
	bridge = BRIDGE.instantiate()
	bridge.position.x = 0
	bridge.position.y = points_water_right[0].y - points_visual[0].y - BRIDGE_DEPTH * .5
	add_child(bridge)
	
	var spawned_pos: Array[Vector2] = []
	var pos: Vector2 
	for f in data.num_enemies:
		pos = choose_farmer_pos(data, spawned_pos)
		spawned_pos.append(pos)
		var farmer = FARMER.instantiate()
		farmer.position = pos
		base.add_child(farmer)
	
	for prop in data.props:
		pos = choose_farmer_pos(data, spawned_pos)
		spawned_pos.append(pos)
		var instance = prop.instantiate()
		instance.position = pos
		base.add_child(instance)
	
	return bridge

func random_farmer_pos(data: LevelGenData) -> Vector2:
	return data.map_size * .4 * randf() * Vector2.DOWN.rotated(TAU * randf())

func choose_farmer_pos(data: LevelGenData, spawned_pos: Array[Vector2]) -> Vector2:
	var pos: Vector2 = random_farmer_pos(data)
	for other_pos in spawned_pos:
		if pos.distance_squared_to(other_pos) < MIN_SQR_DIST_BTWN_ENEMIES:
			return choose_farmer_pos(data, spawned_pos)
	return pos

func get_next_spawn() -> Vector2:
	return bridge.next_level_spawn.global_position
