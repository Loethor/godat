extends CharacterBody2D
class_name Player

# -------------------------
# MOVEMENT TUNING
# -------------------------
@export var move_speed := 360.0
@export var gravity := 1200.0
@export var jump_force := 520.0

# -------------------------
# WEAPON TUNING
# -------------------------
@export var fire_cooldown := 0.3
@export var bullet_scene: PackedScene

var _fire_timer := 0.0

# -------------------------
# GODOT CALLBACKS
# -------------------------

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _physics_process(delta):
	if multiplayer.is_server():
		_server_physics(delta)

func _process(delta):
	_fire_timer -= delta

	# Only the local player sends input
	if not is_multiplayer_authority():
		return

	_send_movement_input()
	_handle_fire_input()

# -------------------------
# SERVER-SIDE PHYSICS
# -------------------------

func _server_physics(delta):
	_apply_gravity(delta)
	move_and_slide()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

# -------------------------
# CLIENT → SERVER INPUT
# -------------------------

func _send_movement_input():
	var dir := Input.get_axis("move_left", "move_right")
	var jump := Input.is_action_just_pressed("jump")

	send_input.rpc(dir, jump)

@rpc("any_peer", "unreliable")
func send_input(dir: float, jump: bool):
	# Executed ONLY on the server
	velocity.x = dir * move_speed

	if jump and is_on_floor():
		velocity.y = -jump_force

# -------------------------
# WEAPON INPUT (CLIENT)
# -------------------------

func _handle_fire_input():
	if not Input.is_action_just_pressed("fire"):
		return

	var dir := (get_global_mouse_position() - global_position).normalized()
	request_fire.rpc(global_position, dir)

# -------------------------
# WEAPON LOGIC (SERVER)
# -------------------------

@rpc("any_peer", "reliable")
func request_fire(origin: Vector2, direction: Vector2):
	# Server-only logic
	if not multiplayer.is_server():
		return

	if _fire_timer > 0.0:
		return

	_fire_timer = fire_cooldown

	if bullet_scene == null:
		push_error("Player: bullet_scene not assigned")
		return

	var bullet := bullet_scene.instantiate()
	bullet.global_position = origin
	bullet.direction = direction

	# Bullets node must exist in the main scene
	var bullets_node := get_tree().current_scene.get_node("Bullets")
	bullets_node.add_child(bullet)
