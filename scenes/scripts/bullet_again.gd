extends Area2D

class_name Bullet
var speed = 10
var move_direction: Vector2 = Vector2.ZERO
var damage

func _process(delta):
	global_position += move_direction * delta * speed

func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
