extends Node2D

const CHUNK = preload("res://grass/grass_spawner.tscn")
const NUMBER_CHUNKS: Vector2i = Vector2i(18, 11)
const CHUNK_SIZE: int = 240

@onready var chunks_parent: Node = $Chunks

var chunk_rows: Array[Variant] = []
var chunk_columns: Array[Variant]  = []

func _ready() -> void:
	initialize()

func initialize() -> void:
	for i in range(NUMBER_CHUNKS.x):
		chunk_rows.append([])
	
	var start: Vector2 = - NUMBER_CHUNKS * CHUNK_SIZE * .5
	
	for x in NUMBER_CHUNKS.x:
		var column: Array[Node2D] = []
		for y in NUMBER_CHUNKS.y:
			var pos: Vector2 = start + Vector2(x, y) * CHUNK_SIZE
		
			var instance = CHUNK.instantiate()
			instance.position = pos
			chunks_parent.add_child(instance)
			
			column.append(instance)
			chunk_rows[x].append(instance)
			
		chunk_columns.append(column)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
