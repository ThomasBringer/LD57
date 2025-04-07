extends Node2D

@onready var particles_trunk: GPUParticles2D = $"../ParticlesTrunk/GPUParticles2D"
@onready var particles_leaves: GPUParticles2D = $"../ParticlesLeaves/GPUParticles2D"
@onready var sprite: Sprite2D = $"../Sprite"

func _on_tree_on_die() -> void:
	owner.show()
	sprite.hide()
	particles_trunk.restart()
	particles_leaves.restart()
