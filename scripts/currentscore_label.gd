extends RichTextLabel

var default_text = "Score: "
func _process(_delta):
	self.text = (str(default_text, str(Global.score)))
