extends Path2D
class_name BSpline

var points: Array[Vector2] = []
@export var line: Line2D

func clear_points() -> void:
	points = []
	curve.clear_points()
	if line:
		line.clear_points()

func add_point(point: Vector2) -> void:
	points.append(point)
	set_bspline()

func pop_front_point() -> void:
	points.pop_front()
	set_bspline()

func set_bspline() -> void:
	curve.clear_points()
	var n: int = points.size()
	
	for i in n:
		var point: Vector2 = points[i]
		if i == 0:
			curve.add_point(point)
		elif i == n-1:
			curve.add_point(point)
		else:
			var prev_point: Vector2 = points[i-1]
			var next_point: Vector2 = points[i+1]
			var handle_out: Vector2 = (next_point - prev_point) / 3
			curve.add_point(point, -handle_out, handle_out)
	
	if line:
		line.points = curve.get_baked_points()
