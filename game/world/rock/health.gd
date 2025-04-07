class_name Health
extends Node2D

@export var health: int = 3
signal on_damage
signal on_die
@onready var flash_timer: Timer = $FlashTimer
@export var next_frame_for_flash: bool = false
var sprite: Sprite2D

@export var play_shovel_sound: bool = true
var saved_colors_dict = {}

func _ready() -> void:
	flash_timer.timeout.connect(_on_flash_timeout)
	save_colors()

func damage() -> void:
	on_damage.emit()
	health -= 1
	flash_white()
	flash_timer.start()

func die() -> void:
	on_die.emit()
	hide()
	#if self is CharacterBody2D:
	self.set_deferred("collision_layer", 0)
	self.set_deferred("collision_mask", 0)
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _on_flash_timeout() -> void:
	if health <= 0:
		die()
	flash_color_back()

#func flash_node(node: Node2D) -> void:
	#if node is CanvasItem:
		#var ci: CanvasItem = node as CanvasItem
		#ci.self_modulate = Color.WHITE
	#for child in node.get_children():
		#flash_node(child)

func save_colors() -> void:
	if next_frame_for_flash:
		sprite = $Sprite
	else:
		do_all_child_cis(self,
			func(ci: CanvasItem):
				saved_colors_dict[ci] = ci.self_modulate
		)

func flash_color_back() -> void:
	if next_frame_for_flash:
		sprite.frame = 0
	else:
		do_all_child_cis(self,
			func(ci: CanvasItem):
				ci.self_modulate = saved_colors_dict[ci]
		)

func flash_white() -> void:
	if next_frame_for_flash:
		sprite.frame = 1
	else:
		do_all_child_cis(self,
			func(ci: CanvasItem):
				ci.self_modulate = Color.WHITE
		)

func do_all_child_cis(node: Node, action) -> void:
	if node is CanvasItem:
		action.call(node)
	for child in node.get_children():
		if child is Node:
			do_all_child_cis(child, action)
