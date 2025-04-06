extends Node2D

const CHUNK = preload("res://grass/grass_spawner.tscn")
const NUMBER_CHUNKS: Vector2i = Vector2i(19, 12)
const CHUNK_SIZE: int = 240

@onready var chunks_parent: Node = $Chunks

var chunk_rows: Array[Variant] = []
var chunk_columns: Array[Variant]  = []

var snapped_pos: Vector2i = Vector2i.ZERO

func _ready() -> void:
	initialize()

var start: Vector2 = (2 * Vector2.DOWN + Vector2.RIGHT - (NUMBER_CHUNKS as Vector2)) * CHUNK_SIZE * .5

func initialize() -> void:
	for i in range(NUMBER_CHUNKS.y):
		chunk_rows.append([])
	
	for x in NUMBER_CHUNKS.x:
		var column: Array[Node2D] = []
		for y in NUMBER_CHUNKS.y:
			var pos: Vector2 = start + Vector2(x, y) * CHUNK_SIZE
		
			var instance = CHUNK.instantiate()
			instance.position = pos
			chunks_parent.add_child(instance)
			
			column.append(instance)
			chunk_rows[y].append(instance)
			
		chunk_columns.append(column)

func snap_to_grid(p: Vector2) -> Vector2i:
	return Vector2i(
		floor(p.x / CHUNK_SIZE),
		floor(p.y / CHUNK_SIZE)
	)

func get_snapped_position() -> Vector2i:
	return snap_to_grid(global_position)

func _process(delta: float) -> void:
	var new_snap: Vector2i = get_snapped_position()
	#print(position, "  -  ", new_snap)
	var diff: Vector2i = new_snap - snapped_pos
	for x in abs(diff.x):
		if diff.x >= 0:
			var column: Array = chunk_columns.pop_front()
			chunk_columns.push_back(column)
			for chunk in column:
				chunk.position.x += NUMBER_CHUNKS.x * CHUNK_SIZE
				chunk.respawn()
		else:
			var column: Array = chunk_columns.pop_back()
			chunk_columns.push_front(column)
			for chunk in column:
				chunk.position.x -= NUMBER_CHUNKS.x * CHUNK_SIZE
				chunk.respawn()
	for y in abs(diff.y):
		if diff.y >= 0:
			var row: Array = chunk_rows.pop_front()
			chunk_rows.push_back(row)
			for chunk in row:
				chunk.position.y += NUMBER_CHUNKS.y * CHUNK_SIZE
				chunk.respawn()
		else:
			var row: Array = chunk_rows.pop_back()
			chunk_rows.push_front(row)
			for chunk in row:
				chunk.position.y -= NUMBER_CHUNKS.y * CHUNK_SIZE
				chunk.respawn()
	
	snapped_pos = new_snap
	
