extends RigidBody2D
@onready var bullet_sprite = $bulletSprite

var spawnPos : Vector2
var dir: int
var speed = 1000

#work on collison
func _ready():
	position = spawnPos
	scale.x = scale.x*dir
	linear_velocity.x = speed * dir
func _physics_process(delta):
	var velocity = Vector2(cos(rotation), sin(rotation)) * speed
	position += velocity * delta

func _on_body_entered(body):
	if body is TileMapLayer || body is RigidBody2D:
		queue_free()
	else:
		body.hit()
		print(body.health)
		queue_free()
