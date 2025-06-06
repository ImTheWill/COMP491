extends Node2D

@export var shooter: PackedScene
@export var turrent: PackedScene
@export var robot: PackedScene
@export var boss: PackedScene

@onready var wave = $UILayer/wave
@onready var overlayMenu = preload("res://scenes/menu/menu_popup.tscn")
var currentWave: int
var startingNodes: int
var currentNodes: int
var wave_spawn_ended: int
var moving_next_wave: bool

func _ready():
	currentWave = 10
	currentNodes = get_child_count()
	startingNodes = get_child_count()
	print("currentN",currentNodes)
	print("startN",startingNodes)
	position_to_next_wave()
 
func _physics_process(_delta):
	if Input.is_action_pressed("Exit"):
		var pause_menu = overlayMenu.instantiate()
		add_child(pause_menu)

func _process(delta):
	currentNodes = get_child_count()
	if(wave_spawn_ended):
		position_to_next_wave()
		wave_spawn_ended = true
	
func position_to_next_wave():
	print("currentNodes:", currentNodes)
	print("startNodes:", startingNodes)
	if currentNodes == startingNodes:
		if currentWave !=0 :
				moving_next_wave = true
		#need to add new/transition wave animation
		currentWave += 1
		await get_tree().create_timer(0.5)
		#prepare_spawn and type
		print(currentWave)
		wave.text = "WAVE " + str(currentWave)
		prepare_spawn("shooter", 3.0, 3.0)
		prepare_spawn("turrent", 1.0, 1.0)
		if currentWave > 2:
			prepare_spawn("Robot", 2.0, 2.0)
		if currentWave%10:
			prepare_spawn("Boss", 1.0, 1.0)

func prepare_spawn(type, multiplier, mobSpawns):
	var mobAmount = float(currentWave) * multiplier
	var mob_wait_time: float = 3.0
	print("mob amount: ", mobAmount)
	var mobSpawnRounds = mobAmount/mobSpawns
	spawnType(type, mobSpawnRounds, mob_wait_time)
	
func spawnType(type, mobSpawnRounds, mob_wait_time):
	if type == "shooter":
		var shooterSpawn = $spawnPointShooter
		if mobSpawnRounds >= 1:
			for i in mobSpawnRounds:
				var shooter1 = shooter.instantiate()
				shooter1.global_position = shooterSpawn.global_position
				add_child(shooter1)
				mobSpawnRounds -=1
				await get_tree().create_timer(mob_wait_time).timeout
	elif type == "turrent":
		var turrentSpawn = $spawnPointTurrent
		var turrentSpawn2 = $spawnPointTurrent2
		if mobSpawnRounds >= 1:
			for i in mobSpawnRounds:
				var turrent1 = turrent.instantiate()
				var turrent2 = turrent.instantiate()
				turrent2.global_position = turrentSpawn2.global_position
				turrent1.global_position = turrentSpawn.global_position
				if mobSpawnRounds > 2:
					add_child(turrent2)
				add_child(turrent1)
				mobSpawnRounds -=1
				await get_tree().create_timer(mob_wait_time).timeout
				
				
	elif type == "Robot":
		var robotSpawn1 = $spawnPointRobot
		var robotSpawn2 = $spawnPointRobot2
		var robotSpawn3 = $spawnPointRobot3
		if mobSpawnRounds >= 1:
			for i in mobSpawnRounds:
				var robot1 = robot.instantiate()
				var robot2 = robot.instantiate()
				var robot3 = robot.instantiate()
				robot1.global_position = robotSpawn1.global_position
				robot2.global_position = robotSpawn2.global_position
				robot3.global_position = robotSpawn3.global_position
				if mobSpawnRounds > 1:
					add_child(robot2)
					if mobSpawnRounds > 2:
						add_child(robot3)
				add_child(robot1)
				mobSpawnRounds -=1
				await get_tree().create_timer(mob_wait_time).timeout
				
	elif type == "Boss":
		var bossSpawn1 = $spawnBoss
		if mobSpawnRounds >= 1:
			for i in mobSpawnRounds:
				var boss1 = boss.instantiate()
				boss1.global_position = bossSpawn1.global_position
				add_child(boss1)
				mobSpawnRounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
	wave_spawn_ended = true
	
	
	
	
	
