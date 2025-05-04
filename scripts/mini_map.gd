extends Node2D

@export var player_path: NodePath
@export var main_map_path: NodePath
@export var enable_auto_marker_scale: bool = true
@export var base_marker_scale: float = 1.0
@export var y_axis_correction: float = 1.0 

@onready var player_ref: Node2D = null
@onready var player_marker: Sprite2D = $SubViewportContainer/SubViewport/PlayerMarker
@onready var main_map_ref: TileMapLayer = null
@onready var minimap_viewport_container: SubViewportContainer = $SubViewportContainer

var main_map_size: Vector2 = Vector2.ZERO
var map_start_pixel: Vector2 = Vector2.ZERO

var virtual_cols: int = 128
var virtual_rows: int = 32
var cell_width: float = 0.0
var cell_height: float = 0.0

var minimap_virtual_cols: int = 16
var minimap_virtual_rows: int = 4
var minimap_cell_width: float = 0.0
var minimap_cell_height: float = 0.0



func _ready():
	
	# Initialize player reference
	if player_path:
		player_ref = get_node(player_path)
		print("MiniMap _ready(): Player ref set to", player_ref)
	else:
		print("MiniMap _ready(): player_path not assigned!")

	# Initialize main map reference
	if main_map_path:
		main_map_ref = get_node(main_map_path)
		print("MiniMap _ready(): Main Map ref set to", main_map_ref)

		var used_rect = main_map_ref.get_used_rect()
		var tile_size = main_map_ref.tile_set.tile_size
		main_map_size = Vector2(used_rect.size.x * tile_size.x, used_rect.size.y * tile_size.y)
		map_start_pixel = Vector2(used_rect.position.x * tile_size.x, used_rect.position.y * tile_size.y)

		print("Main Level TileMap size in pixels:", main_map_size)
		print("Main Map start pixel:", map_start_pixel)
		
		cell_width = main_map_size.x / virtual_cols  
		cell_height = main_map_size.y / virtual_rows 
		print("Each Virtual Cell Size:", cell_width, "x", cell_height)
		
		var minimap_size = $SubViewportContainer/SubViewport.size
		minimap_cell_width = minimap_size.x / minimap_virtual_cols
		minimap_cell_height = minimap_size.y / minimap_virtual_rows
		print("Each MiniMap Cell Size:", minimap_cell_width, "x", minimap_cell_height)
		
		
		
	else:
		print("MiniMap _ready(): main_map_path not assigned!")
		
		
		
	print("======== MiniMap Debug Info ========")
	print("Map Start Pixel:", map_start_pixel)
	print("Main Map Size:", main_map_size)
	print("TileMap Global Position:", main_map_ref.global_position)
	print("Player Global Position:", player_ref.global_position)
	print("MiniMap Viewport Size:", $SubViewportContainer/SubViewport.size)
	print("Virtual Cell Size (MainMap):", cell_width, "x", cell_height)
	print("Virtual Cell Size (MiniMap):", minimap_cell_width, "x", minimap_cell_height)
	print("PlayerMarker Centered:", player_marker.centered)
	print("PlayerMarker Offset:", player_marker.offset)
	print("======== End Debug Info ========")
	print("=== MiniMap SubViewportContainer Info ===")
	print("Global Position:", minimap_viewport_container.global_position)
	print("Size:", minimap_viewport_container.size)
	print("Rect Position (local):", minimap_viewport_container.position)
	
	var minimap_camera = $SubViewportContainer/SubViewport/Camera2D
	if minimap_camera:
		var minimap_size = $SubViewportContainer/SubViewport.size
		minimap_camera.position = minimap_size / 2
		minimap_camera.zoom = Vector2(1, 1)  # Keep zoom 1:1, no additional scaling
		print("MiniMap Camera positioning done. Camera position:", minimap_camera.position)
	else:
		print("MiniMap TileMapLayer node not found!")


func _update_marker_position():
	# Update the player marker position and scale on the MiniMap
	player_marker.visible = false

	if not player_ref or not main_map_ref:
		return

	var player_global_pos = player_ref.global_position
	var adjusted_pos = player_global_pos - main_map_ref.global_position

	var player_virtual_x = int((adjusted_pos.x - map_start_pixel.x) / cell_width)
	var player_virtual_y = int((adjusted_pos.y - map_start_pixel.y) / cell_height)

	print("Virtual Grid X:", player_virtual_x, "Y:", player_virtual_y)

	var minimap_pos_x = player_virtual_x * minimap_cell_width
	var minimap_pos_y = player_virtual_y * minimap_cell_height * y_axis_correction

	var minimap_size = $SubViewportContainer/SubViewport.size
	var minimap_tilemap = $SubViewportContainer/SubViewport/TileMapLayer
	var tilemap_scale = minimap_tilemap.scale if minimap_tilemap else Vector2(1, 1)
	
	player_marker.position = Vector2(minimap_pos_x, minimap_pos_y) * tilemap_scale
	


	player_marker.visible = true
	print("Player Marker Actual Pos:", player_marker.position)

	
func _process(delta):
	# Every frame update marker position
	if not player_ref or not player_marker:
		return
	if not main_map_ref or main_map_size == Vector2.ZERO:
		return
	
	_update_marker_position()



	
	
	
	
	
	
