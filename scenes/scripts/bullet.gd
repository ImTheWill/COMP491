extends RigidBody2D
@onready var bullet_sprite = $bulletSprite

var spawnPos : Vector2
var dir: int
var speed = 1000

func _process(delta):
	#get mouse position in world space
	var target_pos = get_global_mouse_position()
	#calculate the direction vector from the player to the target
	var direction = target_pos - bullet_sprite.global_position
	#set the bullet's rotation to the angle of that vector
	bullet_sprite.rotation = direction.angle()
#work on collison
func _ready():
	position = spawnPos
	scale.x = scale.x*dir
	linear_velocity.x = speed * dir
func _physics_process(_delta):
	pass

func _on_body_entered(body):
	if body is TileMapLayer || body is RigidBody2D:
		queue_free()
	else:
		body.hit()
		print(body.health)
		queue_free()
