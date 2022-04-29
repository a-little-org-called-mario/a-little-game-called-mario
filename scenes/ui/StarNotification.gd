extends RichTextLabel

const VisibleTime = 2


func _ready():
	self.hide()
	EventBus.connect("star_collected", self, "_on_star_collected")


func _on_star_collected(starname: String, again: bool) -> void:
	self.show()
	if not again:
		bbcode_text = "\n" + (tr("[wave amp=50 freq=2]YOU GOT THE STAR:\n[rainbow freq=0.5 sat=1 val=20]%s[/rainbow] [/wave]") % starname)
	else:
		bbcode_text = "\n" + (tr("[wave amp=50 freq=2]YOU GOT THE STAR:\n[rainbow freq=0.5 sat=1 val=20]%s[/rainbow] [/wave]AGAIN") % starname)
	yield(get_tree().create_timer(VisibleTime), "timeout")
	self.hide()
