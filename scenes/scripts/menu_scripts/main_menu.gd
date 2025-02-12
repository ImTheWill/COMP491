extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.play_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main_level.tscn")
	
	

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/settings_menu.tscn")


func _on_exit_pressed():
	get_tree().quit()
