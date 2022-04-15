extends RichTextLabel

const VisibleTime = 2


func _ready():
	self.hide()
	EventBus.connect("star_collected", self, "_on_star_collected")
	EventBus.connect("star_collected_again", self, "_on_star_collected_again")

func _on_star_collected(data: Dictionary):
	self.show()
	bbcode_text = "\n" + (tr("[wave amp=50 freq=2]YOU GOT THE STAR:\n[rainbow freq=0.5 sat=1 val=20]%s[/rainbow] [/wave]") % data["name"])
	yield(get_tree().create_timer(VisibleTime), "timeout")
	self.hide()


func _on_star_collected_again(data: Dictionary):
	self.show()
	bbcode_text = "\n" + (tr("[wave amp=50 freq=2]YOU GOT THE STAR:\n[rainbow freq=0.5 sat=1 val=20]%s[/rainbow] [/wave]AGAIN") % data["name"])
	yield(get_tree().create_timer(VisibleTime), "timeout")
	self.hide()
