extends CharacterBody2D

@export var SPEED = 100
@export var GRAVITY = 800
@export var BULLET = preload("res://scenes/player/bullet.tscn")
@export var SHOOT_COOLDOWN = 1.5  # seconds
const FLIP_THRESHOLD = 16

var player = null
var facing_dir = 1  # 1 = right, -1 = left
var shoot_timer = 0.0

@onready var sprite = $botSprite
@onready var bullet_start = $BulletStart

func _ready():
	# Find player once at start
	player = get_tree().get_root().find_child("Player", true, false)

func _physics_process(delta):
	if player:
		# Gravity
		velocity.y += GRAVITY * delta

		# Vector to player
		var to_player = player.global_position - global_position
		var player_dir = sign(to_player.x)

		# Flip sprite only if player clearly crossed sides
		if player_dir != facing_dir and abs(to_player.x) > FLIP_THRESHOLD:
			facing_dir = player_dir
			sprite.flip_h = (facing_dir == -1)

		# Move towards player
		velocity.x = facing_dir * SPEED
		move_and_slide()

		# Shoot logic
		shoot_timer -= delta
		if shoot_timer <= 0 and abs(to_player.x) > FLIP_THRESHOLD:
			shoot_at_player(to_player)
			shoot_timer = SHOOT_COOLDOWN

func shoot_at_player(to_player):
	# Clamp aim to 180° cone in front of enemy
	var facing_angle = 0.0 if facing_dir == 1 else PI
	var raw_angle = to_player.angle()
	var relative_angle = wrapf(raw_angle - facing_angle, -PI, PI)
	var clamped_relative = clamp(relative_angle, -PI/2, PI/2)
	var final_angle = facing_angle + clamped_relative
	var final_direction = Vector2(cos(final_angle), sin(final_angle))

	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = bullet_start.global_position
	new_bullet.set_direction(final_direction)
	get_tree().current_scene.add_child(new_bullet)

	# Optional: Rotate bullet visually
	new_bullet.rotation = final_direction.angle()
