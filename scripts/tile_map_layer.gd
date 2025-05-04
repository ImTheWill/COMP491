extends TileMapLayer

func _ready():
	
	var cell_size = Vector2(16, 16) 
	
	var used_rect = get_used_rect()
	
	var map_pixel_size = Vector2(used_rect.size) * cell_size
	
	print(" Main Level TileMap size in pixels: ", map_pixel_size)
