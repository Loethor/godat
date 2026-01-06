extends CharacterBody2D
class_name Player

@export var move_speed := 360.0
@export var gravity := 1200.0
@export var jump_force := 520.0

func _enter_tree():
	# Set authority during _enter_tree
	var peer_id = int(name)
	set_multiplayer_authority(peer_id, true)

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Only the owner applies input
	if is_multiplayer_authority():
		var dir := Input.get_axis("move_left", "move_right")
		velocity.x = dir * move_speed

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = -jump_force

	# Everyone moves their own physics
	move_and_slide()
