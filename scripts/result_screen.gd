extends Control


@onready var win_text = $Panel/WinContainer/WinText
@onready var achievement_text = $Panel/VBoxContainer/AchievementRow1/AchievementText
@onready var star_image = $Panel/VBoxContainer/AchievementRow1/StarImage

var star_frame_texture = preload("res://assets/Achievement UI/2.png")
var star_full_texture = preload("res://assets/Achievement UI/1.png")


func _ready():
	
	print("ResultScreen loaded!")

func show_simple_result():
	
	print("show_simple_result() called")
	print("AchievementText node:", achievement_text)
	achievement_text.text = " Defeat boss: "
	
	star_image.texture = star_frame_texture
	
	visible = true
	
	await get_tree().create_timer(1.2).timeout
	star_image.texture = star_full_texture
