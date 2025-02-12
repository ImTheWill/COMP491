extends AudioStreamPlayer


const menu_music = preload("res://assets/audio/game_music/menu_music.wav")

func play_menu_music(music: AudioStream, volume = 0.0):
	if stream == menu_music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_music():
	play_menu_music(menu_music)

#can be used for transition scenes later
func play_FX(stream: AudioStream, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_Player"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()
	
