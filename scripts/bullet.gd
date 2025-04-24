extends RigidBody2D
@onready var bullet_sprite = $bulletSprite

var spawnPos : Vector2
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var speed = 1000


#work on collison
func _ready():
	#add_to_group("Bullet")
	position = spawnPos
	#scale.x = scale.x*dir
	#linear_velocity.x = speed * dir

func _physics_process(delta):
	position += direction * speed * delta
	linear_velocity = velocity

func set_direction(direction: Vector2):
# Set the bullet's velocity in the given direction.
	linear_velocity = direction.normalized() * speed
	velocity = direction.normalized() * speed
	
	rotation = direction.angle()

func _on_body_entered(body):
	if body is TileMapLayer || body is RigidBody2D || body is StaticBody2D:
		queue_free()
	else:
		body.hit(0)
		print(body.health)
		queue_free()
