extends Node

const PORT := 7777
const MAX_CLIENTS := 8

signal server_created
signal client_created

func host():
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	print("Hosting on port", PORT)
	server_created.emit()

func join(ip: String):
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer
	print("Connecting to", ip)
	client_created.emit()
	client_created.emit()
