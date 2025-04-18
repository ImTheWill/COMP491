extends CharacterBody2D

@onready var p_cam = $pCam
@onready var player_sprite = $playerSprite
@onready var BULLET = load("res://scenes/player/bullet.tscn")
@onready var bullet_start = $bulletStart
@onready var ladder_ray = $ladderRay
@onready var ladder_checker_ray = $ladderCheckerRay
@onready var player_health_bar = $HealthBar
@export var inv: Inv 
const MAX_SPEED = 200
const ACCELERATION = 1000
const JUMP_FORCE = -400
const FRICTION = 900
const CLIMB_SPEED = 100
var health = 100

var platform_velocity = Vector2.ZERO
var on_moving_platform = false
var current_platform = null
var is_climbing = false

func _ready():
	add_to_group("Player")
	p_cam.make_current()
	

func _physics_process(delta):
	if global_position.y > 1040 and not is_on_floor():
		get_tree().reload_current_scene()
	
	#Ensure only ladders trigger climbing mode
	var ladder_check_collider = ladder_checker_ray.get_collider()
	var ladder_collider = ladder_ray.get_collider()
	if ladder_collider:
		is_climbing = true
		ladder_climb(delta)
	else:
		is_climbing = false
		player_movement(delta)
		  
	
	#Apply platform movement before move_and_slide
	if on_moving_platform and current_platform:
		#player inherits platform velocity
		velocity += platform_velocity * delta
	
	move_and_slide()
	
	# Re-enable ladder detection when on floor
	if is_on_floor() and not ladder_ray.is_colliding():
		# Safely re-enables ladder detection
		ladder_ray.set_collision_mask_value(2, true)
		
		#Platform Detection Logic (after ladder exit or landing)
		var collision = get_last_slide_collision()
		if collision:
			var collider = collision.get_collider()
			
			#Detect moving platforms even after ladder exit
			if collider and collider.is_in_group("MovingPlatform"):
				current_platform = collider
				on_moving_platform = true
				# Directly sync with platform velocity
				platform_velocity = current_platform.velocity
			else:
				current_platform = null
				on_moving_platform = false
				platform_velocity = Vector2.ZERO
	else:
		current_platform = null
		on_moving_platform = false
		platform_velocity = Vector2.ZERO
		

func ladder_climb(_delta):
	var input := Vector2.ZERO
	
	player_sprite.play("climb")
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_up", "move_down")
	print(input.y)
	if input:
		velocity = input*100
	else:
		velocity = Vector2.ZERO
		if(ladder_ray.get_collider()):
			player_sprite.pause()
	#allows for jumping from ladder
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE
		ladder_ray.set_collision_mask_value(2, false)
		
	if(!ladder_checker_ray.get_collider() and ladder_ray.get_collider() and input.y == -1):
		velocity.y = JUMP_FORCE
		ladder_ray.set_collision_mask_value(2, false)

func player_movement(delta):
	if is_climbing:
		return

	var horizontal_move = Input.get_axis("move_left", "move_right")
	var has_jumped = Input.is_action_just_pressed("jump")

	if is_on_floor() or Input.is_action_pressed("move_up"):
		ladder_ray.set_collision_mask_value(2, true)

	if is_on_floor() and has_jumped:
		velocity.y = JUMP_FORCE
		on_moving_platform = false
		current_platform = null
	else:
		velocity.x += horizontal_move * ACCELERATION * delta / 2
		velocity.y += get_gravity().y * delta

	if horizontal_move != 0 and is_on_floor():
		velocity.x += horizontal_move * ACCELERATION * delta
		player_sprite.flip_h = horizontal_move < 0
				#changes bullet_start position bassed on the direction the player is facing
		if(horizontal_move == -1):
			#if statement reduces constant position change and flickering
			if(bullet_start.position.x > 0):
				bullet_start.rotation_degrees = 180
				bullet_start.position.x = bullet_start.position.x*-1
		elif (horizontal_move == 1):
			#if statement reduces constant position change and flickering
			if(bullet_start.position.x < 0):
				bullet_start.rotation_degrees = 0
				bullet_start.position.x = absf(bullet_start.position.x)
		else: pass
		
	else:
		if is_on_floor():
			if velocity.length() > (FRICTION * delta) and not on_moving_platform:
				velocity.x -= velocity.normalized().x * (FRICTION * delta)
			else:
				velocity.x = 0

	handle_animation(horizontal_move)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

func handle_animation(horizontal_move: float):
	var is_shooting := Input.is_action_pressed("shoot")
	var is_crouched = Input.is_action_pressed("crouch")

	if is_climbing:
		player_sprite.play("climb")
		return

	if is_on_floor():
		if horizontal_move == 0:
			player_sprite.play("shoot" if is_shooting else "idle" if !is_crouched else "crouch")
			if is_shooting and Input.is_action_just_pressed("shoot"):
				shoot()
		else:
			player_sprite.play("run_shoot" if is_shooting else "run")
			if is_shooting and Input.is_action_just_pressed("shoot"):
				shoot()
	else:
		player_sprite.play("jump")

func collect(item):
	inv.insert(item) 

func player():
	pass

func shoot():
	var new_bullet = BULLET.instantiate()
	new_bullet.dir = -1 if player_sprite.flip_h else 1
	new_bullet.spawnPos = bullet_start.global_position
	get_tree().root.add_child(new_bullet)
func hit(direction):
#	velocity.x += 300 * direction
	move_and_slide()
	player_sprite.play("hurt")
	await get_tree().create_timer(0.5).timeout
	if health <= 0:
		get_tree().reload_current_scene()
	else:
		health -= 10
		player_health_bar.change_health(-10)
	print("Damage taken, health is:", health)
