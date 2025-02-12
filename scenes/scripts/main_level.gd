extends Node2D
@onready var overlayMenu = preload("res://scenes/menu/menu_popup.tscn")

func _physics_process(delta):
		if Input.is_action_pressed("Exit"):
			var pause_menu = overlayMenu.instantiate()
			add_child(pause_menu)
