extends Node2D

# Node references
@onready var mini_display: TextureRect = get_node_or_null("MiniMapDisplay")
@onready var viewport: SubViewport = get_node_or_null("SubViewportContainer/MiniMapViewport")
@onready var mini_tilemap: TileMap = get_node_or_null("SubViewportContainer/MiniMapViewport/MiniMapRoot/TileMapLayer")

# Configuration variables
@export var source_tilemap: TileMap
@export var map_scale: float = 0.2
@export var top_left_position: Vector2 = Vector2(20, 20)

func _ready():
	print_debug("=== Minimap Initialization Started ===")

	#  Validate required nodes
	if not _validate_nodes():
		push_error("Minimap initialization failed due to missing nodes.")
		return

	#  Setup display behavior
	_force_display_setup()

	#  Defer tilemap data loading
	call_deferred("initialize_minimap")

func _validate_nodes() -> bool:
	var success = true

	if not mini_tilemap:
		push_error("MiniTileMap not found! Path: " + String(get_path_to(get_node("SubViewportContainer/MiniMapViewport/MiniMapRoot"))))


		success = false

	if not mini_display:
		push_error("MiniMapDisplay (TextureRect) not found!")
		success = false

	if not viewport:
		push_error("SubViewport not found!")
		success = false

	if success:
		print_debug(" ll required nodes are present.")
	return success

func _force_display_setup():
	# Ensure display node properties are correct
	mini_display.position = top_left_position
	mini_display.texture = viewport.get_texture()
	mini_display.scale = Vector2(map_scale, -map_scale)  # Flip Y axis
	mini_display.show()

	# Debug output for verification
	print_debug("Minimap position: ", mini_display.position)
	print_debug("Viewport size: ", viewport.size)
	print_debug("Viewport texture valid: ", viewport.get_texture() != null)

func initialize_minimap():
	if not source_tilemap:
		push_error("Source TileMap is not assigned!")
		return

	print_debug("Initializing minimap data...")

	# Draw a test tile (for visual confirmation)
	mini_tilemap.clear()
	mini_tilemap.set_cell(0, Vector2i(0,0), 0, Vector2i(0,0))
	print_debug("Test tile placed at (0,0)")

	# Proceed to full minimap generation
	update_minimap()

func update_minimap():
	if not source_tilemap or not mini_tilemap:
		return

	print_debug("Updating minimap tiles from source map...")

	mini_tilemap.tile_set = source_tilemap.tile_set.duplicate()

	var cells_copied = 0
	for layer in source_tilemap.get_layers_count():
		for coords in source_tilemap.get_used_cells(layer):
			var tile_data = source_tilemap.get_cell_tile_data(layer, coords)
			if tile_data:
				mini_tilemap.set_cell(
					layer,
					coords,
					source_tilemap.get_cell_source_id(layer, coords),
					source_tilemap.get_cell_atlas_coords(layer, coords),
					source_tilemap.get_cell_alternative_tile(layer, coords)
				)
				cells_copied += 1

	print_debug("Minimap update complete. Copied %d tiles." % cells_copied)
	print_debug("=== Minimap System Ready ===")
