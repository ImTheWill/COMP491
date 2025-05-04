extends Camera2D

@export var move_speed: float = 300  # Camera movement speed

func _ready():
	make_current() # Ensure this camera is active
	print(" TestCamera is active!")  # Debug message

func _process(delta):
	var direction = Vector2.ZERO

	# Move with arrow keys or WASD
	if Input.is_action_pressed("ui_right"):  
		direction.x += 1
	if Input.is_action_pressed("ui_left"):  
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):  
		direction.y += 1
	if Input.is_action_pressed("ui_up"):  
		direction.y -= 1

	# Move the camera if a direction is pressed
	if direction != Vector2.ZERO:
		position += direction.normalized() * move_speed * delta
		print(" Moving Camera to:", position)  # Debugging output
