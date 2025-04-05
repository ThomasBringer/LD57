extends Line2D

@export var nodes: Array[Node2D]

func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_INHERIT
	process_priority = 1
	clear_points()
	for node in nodes:
		if process_priority <= node.process_priority:
			process_priority = node.process_priority + 1
		add_point(node.global_position)

func _process(delta: float) -> void:
	for i in len(nodes):
		var node: Node2D = nodes[i]
		set_point_position(i, node.global_position)
		if i:
			print(node.global_position)
