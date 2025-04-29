extends Node2D


var currentWave: int
@export var shooter: PackedScene
@export var turrent: PackedScene
var startingNodes: int
var currentNodes: int
var wave_spawn_ended: int
var moving_next_wave: bool
@onready var wave = $UILayer/wave




func _ready():
	currentWave = 0
	currentNodes = get_child_count()
	startingNodes = get_child_count()
	print("currentN",currentNodes)
	print("startN",startingNodes)
	position_to_next_wave()
	
func _process(delta):
	currentNodes = get_child_count()
	if(wave_spawn_ended):
		position_to_next_wave()
		wave_spawn_ended = true
	
func position_to_next_wave():
	print("Checking currentN",currentNodes)
	print("Checking startN",startingNodes)
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
		if currentWave > 3:
			prepare_spawn("Robot", 2.0, 2.0)

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
		await get_tree().create_timer(mob_wait_time).timeout
	wave_spawn_ended = true
	
	
	
	
	
