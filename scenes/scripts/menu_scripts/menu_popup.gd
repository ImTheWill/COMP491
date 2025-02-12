extends CanvasLayer

func _ready():
	get_tree().paused = true;

func _on_continue_pressed():
	get_tree().paused = false
	queue_free()

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn");

func _on_quit_pressed():
	get_tree().quit()
