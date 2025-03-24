extends CharacterBody2D

@onready var boss_player_ray = $bossPlayerRay
@onready var boss_floor_ray = $bossFloorRay
@onready var boss_health_bar = $bossHealthBar
@onready var boss_sprite = $bossSprite

var speed = 60
var health = 500
var points_per_kill = 2000

func _ready():
	boss_sprite.play("idle")
	add_to_group("Enemy")

func _physics_process(_delta):
	
	#if boss dies, play death animation and add points
	if(health<=0):
		boss_sprite.play("death")
		await get_tree().create_timer(7).timeout
		Global.score += points_per_kill
		queue_free()



func hit(_direction):
	health -= 10
	boss_health_bar.change_health(-10)
