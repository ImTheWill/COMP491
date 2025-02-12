extends CharacterBody2D
@onready var p_cam = $pCam
@onready var player_sprite = $playerSprite
@onready var BULLET = load("res://scenes/bullet.tscn")
@onready var bullet_start = $bulletStart
@onready var ladder_ray = $ladderRay

#adjustable values
const max_speed = 250 #max speed
const accerlation = 1000 #makes charcter move forward
const jump_accer = -400
const friction = 900 #makes character slow down smoothly when used with delta *****if you make it greator than velocity for x cord then it sticls the player mid air



func _ready():
	p_cam.make_current()#makes the current camera attached to the player the current active one
	
func _physics_process(delta):
	var ladderCollider = ladder_ray.get_collider()
	if ladderCollider:
		ladder_climb(delta)
	else:
		player_movement(delta)
	move_and_slide()


##need to improve and compress the code using two formarts for input for movement and ladder make into one
##reduce redunacy of code 
func ladder_climb(_delta):
	var input := Vector2.ZERO
	
	player_sprite.play("climb")
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_up", "move_down")
	if input:
		velocity = input*100
	else:
		velocity = Vector2.ZERO
		if(ladder_ray.get_collider()):
			player_sprite.pause()
	#allows for jumping from ladder
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_accer
		ladder_ray.set_collision_mask_value(2, false)
	 

func player_movement(delta):
	var horizontal_mov = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var has_jumped = Input.is_action_just_pressed("jump")
	
	#sets ladder raycast to true if abled to
	if is_on_floor() or Input.is_action_pressed("move_up"):
		ladder_ray.set_collision_mask_value(2, true)
	#vertical movement
	if is_on_floor() && has_jumped:
		velocity.y = jump_accer
	else:
		velocity.x += horizontal_mov*accerlation*delta/2
		velocity.y += get_gravity().y*delta
	#horizontal movement
	if (horizontal_mov != 0) && is_on_floor():
		velocity.x += horizontal_mov*accerlation*delta
		player_sprite.flip_h = false if horizontal_mov == 1 else true
		
		#changes bullet_start position bassed on the direction the player is facing
		if(horizontal_mov == -1):
			#if statement reduces constant position change and flickering
			if(bullet_start.position.x > 0):
				bullet_start.rotation_degrees = 180
				bullet_start.position.x = bullet_start.position.x*-1
		elif (horizontal_mov == 1):
			#if statement reduces constant position change and flickering
			if(bullet_start.position.x < 0):
				bullet_start.rotation_degrees = 0
				bullet_start.position.x = absf(bullet_start.position.x)
		else: pass
	else: 
		if is_on_floor(): # allows for retaining velocity while jumping
			if velocity.length() >(friction*delta):
				velocity.x -= velocity.normalized().x*(friction * delta)
			else: velocity = Vector2.ZERO
	handleAnim(horizontal_mov) # reset of animations
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
func handleAnim(horizontal_mov: int):
	var is_shooting := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	var isCrouched = Input.is_action_pressed("crouch")
	
	if is_on_floor():
		if horizontal_mov == 0:
			player_sprite.play("shoot" if is_shooting else "idle" if !isCrouched else "crouch")
			if is_shooting and Input.is_action_just_pressed("shoot"):
				shoot()
				pass
		else:
			player_sprite.play("run_shoot" if is_shooting else "run")
			if is_shooting and Input.is_action_just_pressed("shoot"):
				shoot()
				pass
	else:
		player_sprite.play("jump")
		
		
func shoot():
	var nbullet = BULLET.instantiate()
	nbullet.dir = -1 if player_sprite.flip_h == true else 1 #sets the direction of the bullet
	nbullet.spawnPos = bullet_start.global_position
	get_tree().root.add_child(nbullet)
