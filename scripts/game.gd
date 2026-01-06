extends Node

@onready var players := $Players

@export var player_scene: PackedScene
@export var spawn_positions: Array[Vector2] = [Vector2(100, 300), Vector2(300, 300), Vector2(500, 300), Vector2(700, 300)]

var spawn_index := 0

func _ready():
	# Connect multiplayer signals
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)

	# Listen for when Network creates host
	Network.server_created.connect(_on_server_created)

func _on_server_created():
	print("Server started with ID:", multiplayer.get_unique_id())
	# Host spawns their own player
	_spawn_player(multiplayer.get_unique_id())

func _on_peer_connected(peer_id: int):
	print("Peer connected:", peer_id)
	if not multiplayer.is_server(): return
	# Server spawns player for new peer
	_spawn_player(peer_id)

func _on_connected_to_server():
	print("Connected to server as peer:", multiplayer.get_unique_id())

func _spawn_player(peer_id: int):
	var player := player_scene.instantiate()
	player.name = str(peer_id)

	# Calculate and set spawn position BEFORE adding to tree
	var spawn_pos: Vector2
	if spawn_index < spawn_positions.size():
		spawn_pos = spawn_positions[spawn_index]
	else:
		spawn_pos = Vector2(100 + (spawn_index * 150), 300)
	spawn_index += 1

	# Set position before add_child
	player.position = spawn_pos

	players.add_child(player)
	print("Spawned player for peer:", peer_id, "at", spawn_pos)

func _on_peer_disconnected(peer_id: int):
	if not multiplayer.is_server(): return
	print("Peer disconnected:", peer_id)

	var player_node = players.get_node_or_null(str(peer_id))
	if player_node:
		player_node.queue_free()
