extends Node2D

@export var player: Node2D
const RECENTER_SIZE: int = 480

#func _ready() -> void:
	#process_priority = player.process_priority * 10 + 1
#
#func snap_to_grid(p: Vector2) -> Vector2i:
	#return Vector2i(
		#floor(p.x / RECENTER_SIZE),
		#floor(p.y / RECENTER_SIZE)
	#)
#
#func _process(delta: float) -> void:
	#var snap: Vector2i = snap_to_grid(player.position)
	#if snap:
		#var move_by: Vector2 = - RECENTER_SIZE * snap
		#for child in get_children():
			#child.position += move_by
