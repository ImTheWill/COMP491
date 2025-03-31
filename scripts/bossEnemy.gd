extends CharacterBody2D
signal boss_defeated
signal enemy_defeated 


@onready var boss_health_bar = $bossHealthBar
@onready var boss_sprite = $bossSprite
@onready var boss_collision = $bossCollision
@onready var attack_hitbox = $attackHitbox

var speed = 60
var health = 100
var points_per_kill = 2000

var player = null
var initial_position = Vector2()
var attack_range = 50
var returning = false  # Whether the boss is returning to its position
var is_defeated = false

func _ready():
	boss_sprite.play("idle")
	add_to_group("Enemy")
	initial_position = global_position

func _physics_process(delta):
	# If boss dies, play death animation and add points
	if health <= 0 and not is_defeated:
		
		is_defeated = true 
		#Emit the signal
		emit_signal("boss_defeated")
		emit_signal("enemy_defeated")
		
		boss_sprite.play("death")
		await get_tree().create_timer(3.5).timeout
		Global.score += points_per_kill
		queue_free()
		return
	
	# Return to initial position if player is gone
	if player == null:
		if not returning and global_position.distance_to(initial_position) > 5:
			returning = true  # Start returning
		elif returning:
			move_towards(initial_position, delta)
			boss_sprite.play("walk")
			if global_position.distance_to(initial_position) <= 5:
				velocity = Vector2.ZERO
				boss_sprite.play("idle")
				returning = false
		return

	# If the player is in the area
	var distance_to_player = global_position.distance_to(player.global_position)
	returning = false
	
	if distance_to_player > attack_range:
		# Move towards the player
		move_towards(player.global_position, delta)
		boss_sprite.play("walk")
	else:
		attack()



func move_towards(target, delta):
	var direction = (target - global_position).normalized()
	direction.y = 0  # Prevent movement on the Y-axis
	
	if global_position.distance_to(target) > attack_range:
		velocity = direction * speed
		move_and_slide()
		boss_sprite.play("walk")

		# Flip sprite if moving right or left
		if direction.x < 0:
			boss_sprite.flip_h = false  # Face right
		elif direction.x > 0:
			boss_sprite.flip_h = true   # Face left
	else:
		velocity = Vector2.ZERO  # Stop moving
		boss_sprite.play("idle")


func attack():
	boss_sprite.play("cleave")
	await get_tree().create_timer(0.3).timeout
	attack_hitbox.monitoring = true
	await get_tree().create_timer(0.1).timeout
	attack_hitbox.monitoring = false


# Check if the player is in the platform detection area
func is_player_on_platform():
	return player.is_on_floor()

func hit(_direction):
	health -= 3
	boss_health_bar.change_health(-3)


func _on_boss_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):  # Ensure it only detects the player
		player = body

func _on_boss_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
	returning = true


func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.hit(50)  # Deal 50 damage to the player
