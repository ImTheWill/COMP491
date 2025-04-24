extends CharacterBody2D
signal enemy_defeated

@onready var turrent_ray_front = $turrentRayFront
@onready var turrent_ray_back  = $turrentRayBack
@onready var turrent_sprite = $turrentSprite
@onready var turrent_collision = $turrentCollision
@onready var enemy_health_bar = $EnemyHealthBar
@onready var BULLET = load("res://scenes/player/bullet.tscn")
@onready var bullet_start = $bulletStart
@onready var timer = $Timer


#adjustable values
var facing_right = false
var health = 100
var points_per_kill = 100

func _ready():
	add_to_group("Enemy")
	
func _physics_process(_delta):
	#colliders to detect player
	var turrColliderFront = turrent_ray_front.get_collider()
	var turrColliderBack = turrent_ray_back.get_collider()
	
	#Health
	if(health<=0):
		turrent_sprite.play("death")
		await get_tree().create_timer(.5).timeout
		emit_signal("enemy_defeated")
		Global.score += points_per_kill
		queue_free()
		
	#check If player is nearby
	if (turrColliderFront or turrColliderBack) && timer.is_stopped():
		turrent_sprite.flip_h = true if turrColliderFront else false
		if turrColliderFront:
			if(bullet_start.position.x > 0):
				bullet_start.rotation_degrees = 180
				bullet_start.position.x = bullet_start.position.x*-1
		elif turrent_ray_front:
			if(bullet_start.position.x < 0):
				bullet_start.rotation_degrees = 0
				bullet_start.position.x = absf(bullet_start.position.x)
		shoot()


func shoot():
	var new_bullet = BULLET.instantiate()
	#new_bullet.direction = -1 if turrent_sprite.flip_h else 1
	
	var direction = Vector2.LEFT if turrent_sprite.flip_h else Vector2.RIGHT
	new_bullet.set_direction(direction)

	new_bullet.spawnPos = bullet_start.global_position 
	new_bullet.speed = 500
	get_tree().root.add_child(new_bullet)
	timer.start()
func flip():
	facing_right = !facing_right
	turrent_sprite.flip_h = facing_right
	#add func for flipping based on where payer is left/right
func hit(_direction):
	health -= 10
	enemy_health_bar.change_health(-10)
