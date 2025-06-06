extends Node

#@onready var line: Line2D = $SlashLine
@onready var bspline: BSpline = $SlashPath
@onready var shovel: Node2D = $"../Attack/AttackPivot/HandShovel/ShovelTop"

#@onready var slash_timer: Timer = $"../Slash/SlashTimer"

func clear_slash() -> void:
	bspline.clear_points()
	#path.curve.clear_points()
	#line.clear_points()

func add_first_slash_at_shovel() -> void:
	#slash_timer.start()
	clear_slash()
	add_slash_at_shovel()

func add_slash_at_shovel() -> void:
	add_slash_point(shovel.global_position)

func add_slash_point(point: Vector2) -> void:
	bspline.add_point(point)
	#path.curve.add_point(point)
	#var points = path.curve.get_baked_points()
	#line.points = points

func remove_slash_point() -> void:
	bspline.pop_front_point()
	#path.curve.remove_point(0)
	#var points = path.curve.get_baked_points()
	#line.points = points

#func _on_slash_timer_timeout() -> void:
	#clear_slash()
