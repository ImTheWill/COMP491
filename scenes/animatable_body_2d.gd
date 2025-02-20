extends AnimatableBody2D

@export var move_distance: float = 300
@export var move_speed: float = 80
@export var move_direction: Vector2 = Vector2(1, 0)

var start_position: Vector2
var target_position: Vector2
var moving_forward = true
var velocity: Vector2 = Vector2.ZERO
var passengers: Array[CharacterBody2D] = []

@onready var area_2d = $Area2D

func _ready():
	start_position = global_position
	target_position = start_position + move_direction * move_distance
	
	# Ensure signals are connected
	if !area_2d.body_entered.is_connected(_on_area_2d_body_entered):
		area_2d.body_entered.connect(_on_area_2d_body_entered)
	if !area_2d.body_exited.is_connected(_on_area_2d_body_exited):
		area_2d.body_exited.connect(_on_area_2d_body_exited)
	
	print("Platform initialized at:", start_position)

func _physics_process(delta):
	var previous_position = global_position
	
	# Calculate movement
	if moving_forward:
		velocity = move_direction * move_speed
		global_position += velocity * delta
		if global_position.distance_to(target_position) <= move_speed * delta:
			global_position = target_position
			moving_forward = false
	else:
		velocity = -move_direction * move_speed
		global_position += velocity * delta
		if global_position.distance_to(start_position) <= move_speed * delta:
			global_position = start_position
			moving_forward = true

	# Calculate actual displacement
	var displacement = global_position - previous_position
	
	# Update passengers position
	for passenger in passengers:
		if passenger != null and is_instance_valid(passenger):
			if passenger.is_on_floor() and passenger.on_moving_platform:
				passenger.global_position += displacement
				print("Moving passenger:", passenger.name, " displacement:", displacement)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not passengers.has(body):
		passengers.append(body)
		if body is CharacterBody2D:
			body.on_moving_platform = true
			body.current_platform = self
			body.is_climbing = false
		print("Player entered platform:", body.name)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		passengers.erase(body)
		if body is CharacterBody2D:
			body.on_moving_platform = false
			body.current_platform = null
		print("Player exited platform:", body.name)
