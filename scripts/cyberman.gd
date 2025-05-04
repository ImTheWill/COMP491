extends CharacterBody2D
@onready var cyberman_s: AnimatedSprite2D = $cybermanS
@onready var nav2D: NavigationAgent2D = $NavigationAgent2D
const BULLET = preload("res://scenes/player/bullet.tscn")
@onready var bullet_start = $bulletStart
@onready var timer: Timer = $Timer


const MAX_SPEED = 100
const ACCELERATION = 1000
const JUMP_FORCE = -400
const FRICTION = 900
var health = 100

var facing_right = true
var has_jumped = false
var is_shooting = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var playerPos = getPlayerPos()
	#print("PlayerPositionFunc: ", playerPos)
	#detectPlayer if in Shooting Area
	var shootingArea = $shootArea
	if (shootingArea.get_collider() != null) && shootingArea.get_collider().is_in_group("Player") &&timer.is_stopped():
		is_shooting = true
		shoot()
	move(playerPos,delta)
	move_and_slide()


func move(playerPos, delta):
	if playerPos!=null:
		nav2D.target_position = playerPos
		if nav2D.is_navigation_finished():
			return
		var next_path_position: Vector2 = nav2D.get_next_path_position()
		velocity.x = (global_position.direction_to(next_path_position).x*MAX_SPEED)
		velocity.y += get_gravity().y * delta
		print("Velocity: ",(global_position.direction_to(next_path_position)*MAX_SPEED))
		
	
func getPlayerPos():
	for child in get_tree().get_nodes_in_group("Player"):
		if child.is_in_group("Player"):
			return child.get_global_position()

func shoot():
	var new_bullet = BULLET.instantiate()
	new_bullet.sprite = "cyberman"
	new_bullet.set_direction(Vector2.RIGHT if facing_right else Vector2.LEFT)
	new_bullet.spawnPos = bullet_start.global_position
	new_bullet.speed = 800
	get_tree().root.add_child(new_bullet)
	timer.start()
	is_shooting = false
	
func hit(_direction):
	cyberman_s.play("Hit")
	await get_tree().create_timer(0.5).timeout
	if health <= 0:
		queue_free()
	else:
		health -= 10
	print("Damage taken, health is:", health)
	
	
	
