extends Control
@onready var option_button = $HBoxContainer2/resolution_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	option_button.item_selected.connect(on_resolution_selected)
	add_resolution_items()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

const Resolution_Dictionary: Dictionary = {
	"640 x 360" :Vector2i(640, 360),
	"1280 x 720" :Vector2i(1280, 720 ),
	"1920 x 1080" :Vector2i(1920,1080)
}
func add_resolution_items()-> void:
	for resolution_size_text in Resolution_Dictionary:
		option_button.add_item(resolution_size_text)


func on_resolution_selected(index : int ) -> void:
	DisplayServer.window_set_size(Resolution_Dictionary.values()[index])
	
