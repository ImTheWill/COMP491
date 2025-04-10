extends StaticBody2D

@export var item: InvItem

var player = null

func playercollect():
	player.collect(item)


func _on_interactable_area_body_entered(body):
	if body.has_method("player"):
		player = body
		playercollect()
		self.queue_free()
