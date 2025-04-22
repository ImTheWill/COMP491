extends Node2D


var currentWave: int
@export var shooter: PackedScene
@export var turrent: PackedScene
var startingNodes: int
var currentNodes: int
var wave_spawn_ended: int
var moving_next_wave: bool

func _ready():
	currentWave = 3
	currentNodes = get_child_count()
	startingNodes = get_child_count()
	position_to_next_wave()
	
func _process(delta):
	currentNodes = get_child_count()
	if(wave_spawn_ended):
		position_to_next_wave()
		wave_spawn_ended = true
	
func position_to_next_wave():
	if currentNodes == startingNodes:
		if currentWave !=0 :
				moving_next_wave = true
		#need to add new/transition wave animation
		currentWave += 1
		await get_tree().create_timer(0.5)
		#prepare_spawn and type
		print(currentWave)
		prepare_spawn("shooter", 3.0, 3.0)
		prepare_spawn("turrent", 1.0, 1.0)

func prepare_spawn(type, multiplier, mobSpawns):
	var mobAmount = float(currentWave) * multiplier
	var mob_wait_time: float = 2.0
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
		if mobSpawnRounds >= 1:
			for i in mobSpawnRounds:
				var turrent1 = turrent.instantiate()
				turrent1.global_position = turrentSpawn.global_position
				add_child(turrent1)
				mobSpawnRounds -=1
				await get_tree().create_timer(mob_wait_time).timeout
	wave_spawn_ended = true
	
	
	
	
	
