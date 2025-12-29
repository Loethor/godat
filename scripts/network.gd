extends Node

const PORT := 7777
const MAX_CLIENTS := 8

func host():
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	print("Hosting on port", PORT)

func join(ip: String):
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer
	print("Connecting to", ip)
