extends Control

@onready var master_slider = $TabContainer/Sound/Master/BoxContainer/master_slider
@onready var sfx_slider = $TabContainer/Sound/SFX/BoxContainer/sfx_slider
@onready var music_slider = $TabContainer/Sound/Music/BoxContainer/music_slider

func _ready():
	var audio_settings = ConfigFileHandler.load_audio_setting()
	master_slider.value = min(audio_settings.master_volume, 1.0)
	sfx_slider.value = min(audio_settings.sfx_volume, 1.0)
	music_slider.value = min(audio_settings.music_volume, 1.0)

func _process(delta):
	if Input.is_action_pressed("Exit"): 
		get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func _on_master_slider_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_setting("master_volume", master_slider.value )


func _on_sfx_slider_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_setting("sfx_volume", sfx_slider.value )



func _on_music_slider_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_setting("music_volume", music_slider.value )
