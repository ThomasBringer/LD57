class_name Health
extends StaticBody2D

@export var health: int = 3
signal on_die
@onready var flash_timer: Timer = $FlashTimer

var saved_colors_dict = {}

func _ready() -> void:
	flash_timer.timeout.connect(_on_flash_timeout)
	save_colors()

func damage() -> void:
	health -= 1
	if health <= 0:
		die()
	else:
		flash_white()
		flash_timer.start()

func die() -> void:
	on_die.emit()
	queue_free()

func _on_flash_timeout() -> void:
	flash_color_back()

#func flash_node(node: Node2D) -> void:
	#if node is CanvasItem:
		#var ci: CanvasItem = node as CanvasItem
		#ci.self_modulate = Color.WHITE
	#for child in node.get_children():
		#flash_node(child)

func save_colors() -> void:
	do_all_child_cis(self,
		func(ci: CanvasItem):
			saved_colors_dict[ci] = ci.self_modulate
	)

func flash_color_back() -> void:
	do_all_child_cis(self,
		func(ci: CanvasItem):
			ci.self_modulate = saved_colors_dict[ci]
	)

func flash_white() -> void:
	do_all_child_cis(self,
		func(ci: CanvasItem):
			ci.self_modulate = Color.WHITE
	)

func do_all_child_cis(node: Node2D, action) -> void:
	if node is CanvasItem:
		action.call(node)
	for child in node.get_children():
		if child is Node2D:
			do_all_child_cis(child, action)
