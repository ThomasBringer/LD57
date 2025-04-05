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
	
	if n <= 2:
		if n > 0:
			curve.add_point(points[0])
		if n > 1:
			curve.add_point(points[1])
	
	elif n== 3:
		var handle_out_start: Vector2 = (points[1] + 2 * points[0]) / 3
		var handle_in_mid: Vector2 = (points[0] + 2 * points[1]) / 3
		var handle_out_mid: Vector2 = (points[2] + 2 * points[1]) / 3
		var handle_out_end: Vector2 = (points[1] + 2 * points[2]) / 3
		var mid: Vector2 = (handle_in_mid + handle_out_mid) *.5
		curve.add_point(points[0], Vector2.ZERO, handle_out_start - points[0])
		curve.add_point(mid, handle_in_mid - mid, handle_out_mid - mid)
		curve.add_point(points[2], handle_out_end - points[2], Vector2.ZERO)
	
	else:
		for i in n:
			var point: Vector2 = points[i]
			if i == 0:
				var next_point: Vector2 = points[1]
				var next_handle: Vector2 = (next_point + 2 * point) / 3
				var rel_next_handle: Vector2 = next_handle - point
				curve.add_point(point, Vector2.ZERO, rel_next_handle)
			elif i == n-1:
				var prev_point: Vector2 = points[n-2]
				var prev_handle: Vector2 = (prev_point + 2 * point) / 3
				var rel_prev_handle: Vector2 = prev_handle - point
				curve.add_point(point, rel_prev_handle, Vector2.ZERO)
			else:
				var prev_point: Vector2 = points[i-1]
				var next_point: Vector2 = points[i+1]
				var prev_handle: Vector2 = (prev_point + 2 * point) / 3
				var next_handle: Vector2 = (next_point + 2 * point) / 3
				var mid: Vector2 = (prev_handle + next_handle) * .5
				var rel_prev_handle: Vector2 = prev_handle - mid
				var rel_next_handle: Vector2 = next_handle - mid
				curve.add_point(mid, rel_prev_handle, rel_next_handle)
	
	if line:
		line.points = curve.get_baked_points()
