extends Node

const DEFAULT_PORT := 6784
const MAX_CLIENTS := 8

signal server_created
signal client_created

func host():
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(DEFAULT_PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	print("Server created!")
	print("Hosting on port: ", DEFAULT_PORT)
	server_created.emit()

func join(host_ip: String = "localhost", host_port: int = DEFAULT_PORT):
	_setup_client_connection_signals()

	var peer := ENetMultiplayerPeer.new()
	peer.create_client(host_ip, host_port)
	multiplayer.multiplayer_peer = peer
	print("Connecting to: ", host_ip)
	client_created.emit()

func _setup_client_connection_signals() -> void:
	if not multiplayer.server_disconnected.is_connected(_on_server_disconnected):
		multiplayer.server_disconnected.connect(_on_server_disconnected)

func _on_server_disconnected() -> void:
	print("Server disconnected!")
	multiplayer.multiplayer_peer = null
