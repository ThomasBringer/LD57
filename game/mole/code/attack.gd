extends Node2D

@onready var anim: AnimationPlayer = $AnimAttack

var anim_i: int = 1

@onready var pivot: Node2D = $AttackPivot

@onready var hand_shovel: Node2D = $AttackPivot/HandShovel

const TOLERANCE: float = .3

@onready var mole_movement: Node2D = $"../MoleMovement"

func is_pointing_front(pivot: Node2D) -> bool:
	var dir = pivot.global_transform.x
	return dir.dot(Vector2.DOWN) >= - TOLERANCE

func order(pivot: Node2D, node: Node2D, z: int) -> void:
	node.z_index = -z if is_pointing_front(pivot) else z

func _process(delta: float) -> void:
	if anim.is_playing(): return
	order(pivot, hand_shovel, 50)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and not anim.is_playing() and not mole_movement.is_underground:
		attack()

func attack() -> void:
	play_anim()

func play_anim() -> void:
	anim.play("attack" + str(anim_i))
	anim_i = 3 - anim_i
