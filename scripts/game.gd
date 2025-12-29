extends Node

@onready var players := $Players

@export var player_scene: PackedScene

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	if multiplayer.is_server():
		print("Server started with ID:", multiplayer.get_unique_id())

func _on_peer_connected(peer_id: int):
	print("Peer connected:", peer_id)
	if not multiplayer.is_server(): return

	var player := player_scene.instantiate()
	player.name = str(peer_id)
	players.add_child(player)


func _on_peer_disconnected(peer_id: int):
	if not multiplayer.is_server(): return
	print("Peer disconnected:", peer_id)

	for p in players.get_children():
		if p.get_multiplayer_authority() == peer_id:
			p.queue_free()
