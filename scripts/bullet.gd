extends Area2D

@export var speed = 500
var direction = Vector2.ZERO

func set_direction(dir: Vector2):
	direction = dir.normalized()
	rotation = direction.angle()

func _physics_process(delta):
	position += direction * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_bullet_body_entered(body):
	# Don't damage the bullet's owner (optional; remove if unnecessary)
	if body == self.get_owner():
		return

	# Check if the body has a take_damage method
	if body.has_method("hit"):
		body.hit(10)  # deal 10 damage

	queue_free()
