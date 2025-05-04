extends RigidBody2D
@onready var bullet_sprite = $bulletSprite
@onready var timer = $Timer

var spawnPos : Vector2
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var speed = 1000
var sprite = ""


#work on collison
func _ready():
	#add_to_group("Bullet")
	bullet_sprite.play(sprite)
	position = spawnPos
	#scale.x = scale.x*dir
	#linear_velocity.x = speed * dir

func _physics_process(delta):
	if timer.is_stopped():
		queue_free()
	position += direction * speed * delta
	linear_velocity = velocity

func set_direction(direction: Vector2):
# Set the bullet's velocity in the given direction.
	linear_velocity = direction.normalized() * speed
	velocity = direction.normalized() * speed
	
	rotation = direction.angle()

func _on_body_entered(body):
	velocity = velocity*0 #stops the bullet once it hits something 
	if body is TileMapLayer || body is TileMap || body is RigidBody2D || body is StaticBody2D:
		if(sprite == "cyberman"):
			bullet_sprite.play("cybermanExplosion")
			await get_tree().create_timer(1.0).timeout
		queue_free()
	else:
		body.hit(0)
		print(body.health)
		if(sprite == "cyberman"):
			bullet_sprite.play("cybermanExplosion")
			set_collision_layer_value(1,false)
			set_collision_mask_value(1,false)
			set_collision_mask_value(3,false)
			await get_tree().create_timer(1.0).timeout
		queue_free()
