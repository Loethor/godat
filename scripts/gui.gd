extends Control

@onready var title_label: Label = %TitleLabel
@onready var ip_line_edit: LineEdit = %IpLineEdit
@onready var host_button: Button = %HostButton
@onready var join_button: Button = %JoinButton

func _ready():
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)

func _on_host_pressed():
	Network.host()
	hide()

func _on_join_pressed():
	var ip := ip_line_edit.text.strip_edges()
	if ip.is_empty():
		ip = "127.0.0.1"

	Network.join(ip)
	hide()
