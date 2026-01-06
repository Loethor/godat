extends Node2D


var spawn_positions: Array[Vector2] = []

func _ready() -> void:
	spawn_positions.clear()
	var spawn_parent = $SpawnPositions
	for child in spawn_parent.get_children():
		if child is Marker2D:
			spawn_positions.append(child.position)
