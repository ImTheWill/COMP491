extends RigidBody2D
@onready var bullet_sprite = $bulletSprite

var spawnPos : Vector2
var direction = Vector2.ZERO
@export var speed = 1000


#work on collison
func _ready():
	position = spawnPos
	#scale.x = scale.x * direction
	#linear_velocity.x = speed * direction
	
func _physics_process(delta):
	position += direction * speed * delta

func set_direction(direction: Vector2):
# Set the bullet's velocity in the given direction.
	linear_velocity = direction.normalized() * speed
	rotation = direction.angle()
	
func _on_body_entered(body):
	if body is TileMapLayer || body is RigidBody2D || body is StaticBody2D:
		queue_free()
	else:
		body.hit(0)
		print(body.health)
		queue_free()
