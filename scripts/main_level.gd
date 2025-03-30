extends Node2D

@onready var overlayMenu = preload("res://scenes/menu/menu_popup.tscn")
@onready var player_health_bar = $HealthBar
@onready var achievement_system = $AchievementSystem
@onready var boss = $bossEnemy

@onready var result_screen = $CanvasLayer/ResultScreen

func _ready():

	result_screen.visible = false
	
	$Player.player_health_bar = $CanvasLayer/HealthBar
	
	boss.boss_defeated.connect(_on_boss_defeated)

func _on_boss_defeated():
	
	print("Boss defeated! Unlocking achievement...")
	achievement_system.unlock_achievement("defeat_boss")
	result_screen.show_simple_result()
	get_tree().paused = true
