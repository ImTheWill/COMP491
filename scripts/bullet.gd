extends RigidBody2D
@onready var bullet_sprite = $bulletSprite

var spawnPos : Vector2
var dir: int
var speed = 1000


#work on collison
func _ready():
	add_to_group("Bullet")
	position = spawnPos
	scale.x = scale.x*dir
	linear_velocity.x = speed * dir
func _physics_process(_delta):
	pass

func _on_body_entered(body):
	if body is TileMapLayer || body is RigidBody2D || body is StaticBody2D:
		queue_free()
	else:
		body.hit(0)
		print(body.health)
		queue_free()
