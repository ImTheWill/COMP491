extends RichTextLabel

var default_text = "Score: "
func _process(_delta):
	var text = str(default_text, str(Global.score))
	self.text = (text)
