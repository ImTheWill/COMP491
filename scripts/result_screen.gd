extends Control


@onready var win_text = $Panel/WinContainer/WinText
@onready var achievement_text = $Panel/VBoxContainer/AchievementText


func _ready():
	
	print("ResultScreen loaded!")

func show_simple_result():
	
	print("show_simple_result() called")
	print("AchievementText node:", achievement_text)
	achievement_text.text = "Achievement unlocked: Defeat the boss"
	visible = true
