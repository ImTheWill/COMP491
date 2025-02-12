extends RigidBody2D
@onready var bullet_sprite = $bulletSprite

var spawnPos : Vector2
var dir: int
var speed = 300


#work on collison
func _ready():
	position = spawnPos
	scale.x = scale.x*dir
	linear_velocity.x = linear_velocity.x * dir
func _physics_process(_delta):
	pass

func _on_body_entered(body):
	if body is TileMapLayer:
		queue_free()
	else:
		body.health -=10;
		print(body.health)
		queue_free()
