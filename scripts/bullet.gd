extends Area2D
class_name Bullet

@export var speed := 900.0
@export var lifetime := 2.0

var direction := Vector2.ZERO


func _physics_process(delta):
	position += direction * speed * delta
	lifetime -= delta

	if lifetime <= 0.0:
		queue_free()

func _on_body_entered(_body):
	queue_free()
