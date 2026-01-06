extends Control

@onready var title_label: Label = %TitleLabel
@onready var ip_line_edit: LineEdit = %IpLineEdit
@onready var host_button: Button = %HostButton
@onready var join_button: Button = %JoinButton
@onready var status_label: Label = %StatusLabel

func _ready():
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)

	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.connection_failed.connect(_on_connection_failed)

func _on_host_pressed():
	status_label.text = "Hosting..."
	hide()
	Network.host()

func _on_join_pressed():
	var ip := ip_line_edit.text.strip_edges()
	if ip.is_empty():
		ip = "127.0.0.1"

	status_label.text = "Connecting to %s..." % ip
	Network.join(ip)
	hide()

func _on_connected():
	status_label.text = "Connected!"

func _on_connection_failed():
	status_label.text = "Connection failed"
