extends CharacterBody2D
signal enemy_defeated

@onready var bot_player_ray = $botPlayerRay
@onready var bot_floor_ray = $botFloorRay
@onready var enemy_health_bar = $EnemyHealthBar
@onready var bullet_start = $bulletStart
#@export var bullet_start: Node2D
@onready var bot_sprite = $botSprite
@onready var timer = $Timer
@onready var BULLET = load("res://scenes/player/bullet.tscn")
#@export var BULLET: PackedScene
@onready var area2d = $Area2D
@export var move_speed = 150
@export var shoot_cooldown = 0.5  # Seconds between shots
@onready var turret_sprite = $TurretSprite


var speed = 60
var facing_right = false
var health = 100
var points_per_kill = 100
var player: Node2D
var can_shoot = true

func _ready():
	bot_sprite.play("patrol")
	add_to_group("Enemy")
	timer.wait_time = shoot_cooldown
	timer.one_shot = true
 # Recursively search for node named "Player"
	player = get_tree().current_scene.find_child("Player", true, false)

	if player == null:
		print("Player not found in scene!")	# res://scenes/player/player.tscn
	# if not player:
		# print("Player not found in scene!")
	
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
		
	if player == null or !is_instance_valid(player):
		player = get_tree().current_scene.find_child("Player", true, false)

	if player != null and is_instance_valid(player):
		# Move towards player
		var direction_to_player = (player.global_position - global_position).normalized()
		velocity.x = direction_to_player.x * move_speed
		move_and_slide()

		# Aim turret at player
		var to_player = player.global_position - bullet_start.global_position
		turret_sprite.rotation = to_player.angle()

		# Shoot if player is in front (0-180 degrees)
		var facing_vector = Vector2.RIGHT.rotated(rotation)
		var angle_to_player = facing_vector.angle_to(to_player.normalized())

		if abs(angle_to_player) < PI / 2 and can_shoot:  # Only shoot if player is roughly in front
			shoot()

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
	if not BULLET:
		return

	print("has shot")
	var new_bullet = BULLET.instantiate()
	new_bullet.spawnPos = bullet_start.global_position

	# Calculate direction to player
	var shoot_dir = (player.global_position - bullet_start.global_position).normalized()
	new_bullet.set_direction(shoot_dir)  # Assuming bullet.gd has set_direction()

	#var direction = Vector2.LEFT if bot_sprite.flip_h else Vector2.RIGHT
	#new_bullet.set_direction(direction)
	
	# new_bullet.spawnPos = bullet_start.global_position 
	new_bullet.speed = 500
	get_tree().root.add_child(new_bullet)

	can_shoot = false
	timer.start()

func _on_timer_timeout():
	can_shoot = true


func hit(_direction):
		health -= 10
		enemy_health_bar.change_health(-10)
	
