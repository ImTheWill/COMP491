extends Control

@onready var option_button = $HBoxContainer/window_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	add_window_mode_items()
	option_button.item_selected.connect(on_window_mode_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

const WINDOW_MODE_ARRAY : Array[String] = [
	"Full Screen",
	"Window Mode",
	"Borderless Window"
]

func add_window_mode_items() -> void:
	for i in WINDOW_MODE_ARRAY:
		option_button.add_item(i)
	
func on_window_mode_selected(index : int) -> void:
	match index:
		0: #fullsfcreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
