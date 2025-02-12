extends CharacterBody2D
@onready var robot_ray = $robotRay
@onready var robot_anim_sprite = $robotAnimSprite

#adjustable values
var speed = 60
var facing_right = false
var health = 100


func _ready():
	robot_anim_sprite.play("patrolWalk")
func _physics_process(delta):
	if(health<=0):
		robot_anim_sprite.play("death")
		await get_tree().create_timer(.5).timeout
		queue_free()
	if not is_on_floor():
		velocity.y += get_gravity().y *delta
	if !robot_ray.is_colliding() && is_on_floor():
		flip()
		
	velocity.x = speed
	move_and_slide()
	for i in get_slide_collision_count():
		var bodyCollided = get_slide_collision(i).get_collider()
		if bodyCollided.is_in_group("Player"):
			bodyCollided.hit()

func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)*-1
	else:
		speed = abs(speed)
