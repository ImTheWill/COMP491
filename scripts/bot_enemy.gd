extends CharacterBody2D
signal enemy_defeated

@onready var bot_player_ray = $botPlayerRay
@onready var bot_floor_ray = $botFloorRay
@onready var enemy_health_bar = $EnemyHealthBar
@onready var bullet_start = $bulletStart
@onready var bot_sprite = $botSprite
@onready var timer = $Timer
@onready var BULLET = load("res://scenes/player/bullet.tscn")
@onready var area2d = $Area2D

var speed = 60
var facing_right = false
var health = 100
var points_per_kill = 100

func _ready():
	bot_sprite.play("patrol")
	add_to_group("Enemy")
	
func _physics_process(delta):
	var botPlayerRay = bot_player_ray.get_collider()

		
	if(health<=0):
		bot_sprite.play("death")
		await get_tree().create_timer(.5).timeout
		emit_signal("enemy_defeated")
		Global.score += points_per_kill
		queue_free()
	if botPlayerRay && timer.is_stopped():
		if(botPlayerRay!=null):
			if botPlayerRay.is_in_group("Player"):
				shoot()
			elif botPlayerRay.is_in_group("Enemy"):
				set_collision_mask_value(1,false)
	if not is_on_floor():
		velocity.y += get_gravity().y *delta
	if !bot_floor_ray.is_colliding() && is_on_floor():
		flip()
		
	velocity.x = speed
	move_and_slide()



func flip():
	bot_floor_ray.position.x = abs(bot_floor_ray.position.x) if facing_right else abs(bot_floor_ray.position.x)*-1
	bot_player_ray.scale.x = abs(bot_player_ray.scale.x) if facing_right else abs(bot_player_ray.scale.x)*-1
	#bulletStartPos
	if(bullet_start.position.x > 0):
		bullet_start.rotation_degrees = 180
		bullet_start.position.x = bullet_start.position.x*-1
	elif(bullet_start.position.x < 0):
		bullet_start.rotation_degrees = 0
		bullet_start.position.x = absf(bullet_start.position.x)
		
	facing_right = !facing_right
	bot_sprite.flip_h = facing_right
	if facing_right:
		speed = abs(speed)*-1
	else:
		speed = abs(speed)
func shoot():
	print("has shot")
	var new_bullet = BULLET.instantiate()
	new_bullet.direction = Vector2(-1,0) if bot_sprite.flip_h else Vector2(1,0)
	new_bullet.spawnPos = bullet_start.global_position 
	new_bullet.speed = 500
	get_tree().root.add_child(new_bullet)
	timer.start()

func hit(_direction):
		health -= 10
		enemy_health_bar.change_health(-10)
	
