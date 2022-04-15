extends RichTextLabel

const VisibleTime = 2


func _ready():
	self.hide()
	EventBus.connect("star_collected", self, "_on_star_collected")
	EventBus.connect("star_collected_again", self, "_on_star_collected_again")

func _on_star_collected(data: Dictionary):
	self.show()
	bbcode_text = "\n" + (tr("STARCOLLECT") % data["name"])
	yield(get_tree().create_timer(VisibleTime), "timeout")
	self.hide()

func _on_star_collected_again(data: Dictionary):
	self.show()
	bbcode_text = "\n" + (tr("STARCOLLECTAGAIN") % data["name"])
	yield(get_tree().create_timer(VisibleTime), "timeout")
	self.hide()
