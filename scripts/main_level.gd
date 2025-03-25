extends Node2D
@onready var overlayMenu = preload("res://scenes/menu/menu_popup.tscn")
@onready var player_health_bar = $HealthBar

func _physics_process(_delta):
		if Input.is_action_pressed("Exit"):
			var pause_menu = overlayMenu.instantiate()
			add_child(pause_menu)
