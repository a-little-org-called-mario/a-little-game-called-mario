extends RichTextLabel

const VisibleTime = 2
var currentLevel := 1


func _ready():
	EventBus.connect("level_started", self, "_on_level_started")
	EventBus.connect("level_completed", self, "_on_level_completed")
	_on_level_started({})


func _on_level_started(_data):
	self.show()
	bbcode_text = "\n" + (tr("[wave amp=50 freq=2]LEVEL:[rainbow freq=0.5 sat=1 val=20]%d[/rainbow] [/wave]") % currentLevel)
	yield(get_tree().create_timer(VisibleTime), "timeout")
	self.hide()


func _on_level_completed(_data):
	currentLevel += 1
