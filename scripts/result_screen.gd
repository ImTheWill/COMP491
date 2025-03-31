extends Control

# UI nodes for boss achievement
@onready var win_text = $Panel/WinContainer/WinText
@onready var achievement_text = $Panel/VBoxContainer/AchievementRow1/AchievementText
@onready var star_image = $Panel/VBoxContainer/AchievementRow1/StarImage

# UI nodes for enemy achievement (second row)
@onready var enemy_text = $Panel/VBoxContainer/AchievementRow2/AchievementText2
@onready var star_enemy_1 = $Panel/VBoxContainer/AchievementRow2/StarImage1
@onready var star_enemy_2 = $Panel/VBoxContainer/AchievementRow2/StarImage2
@onready var star_enemy_3 = $Panel/VBoxContainer/AchievementRow2/StarImage3




# Textures for empty and full stars
var star_frame_texture = preload("res://assets/Achievement UI/2.png")
var star_full_texture = preload("res://assets/Achievement UI/1.png")


# Enemy stats
var total_enemies := 0
var enemies_killed := 0

func _ready():
	
	print("ResultScreen loaded!")

# Show simple result with "Defeat Boss" achievement
func show_simple_result():
	
	print("show_simple_result() called")
	# Show result screen
	visible = true
	
	
	print("AchievementText node:", achievement_text)
	
	# Set Boss UI text and empty star
	achievement_text.text = " Defeat boss: "
	star_image.texture = star_frame_texture
	
	
	# Set enemy UI text and empty stars
	var all_enemies = get_tree().get_nodes_in_group("Enemy")
	total_enemies = all_enemies.size()
	enemies_killed = 0

	# Connect kill signal from all enemies
	for enemy in all_enemies:
		if enemy.has_signal("enemy_defeated"):
			enemy.enemy_defeated.connect(_on_enemy_killed)
			print(" Connected to:", enemy.name)
		else:
			print(" No signal on:", enemy.name)
	
	
	# Update label
	enemy_text.text = " Defeat enemies:"
	
	
	var star_list = [star_enemy_1, star_enemy_2, star_enemy_3]
	for star in star_list:
		star.texture = star_frame_texture
	
	# Delay before showing full stars
	await get_tree().create_timer(1.1).timeout
	
	# Boss star → full
	star_image.texture = star_full_texture
	
	# Initialize the enemy achievement display
	#show_enemy_achievement()


# Called when an enemy is killed
func _on_enemy_killed():
	
	enemies_killed += 1
	print("Enemies killed: ", enemies_killed)
	await get_tree().create_timer(1.1).timeout
	show_enemy_achievement()

# Update enemy star rating and display
func show_enemy_achievement():
	var ratio := float(enemies_killed) / total_enemies
	var stars := 0
	
	# Determine star count based on kill ratio
	if ratio >= 0.9:
		stars = 3
	elif ratio >= 0.7:
		stars = 2
	elif ratio >= 0.3:
		stars = 1
	
	# Update label
	enemy_text.text = " Defeat enemies:"
	
	# Set all to empty stars
	var star_list = [star_enemy_1,star_enemy_2,star_enemy_3]
	for i in range(3):
		star_list[i].texture = star_full_texture if i < stars else star_frame_texture

	
