extends RichTextLabel

export (NodePath) onready var timer = get_node(timer) as Timer
export(float) var visible_time: float = 2.0
var current_level: int = 1


func _ready() -> void:
	EventBus.connect("level_started", self, "_on_level_started")
	EventBus.connect("level_completed", self, "_on_level_completed")
	EventBus.connect("hub_entered", self, "_on_hub_entered")
	_on_level_started("")


func _on_level_started(_name: String) -> void:
	self.show()
	bbcode_text = "\n" + (tr("[wave amp=50 freq=2]LEVEL:[rainbow freq=0.5 sat=1 val=20]%d[/rainbow] [/wave]") % current_level)
	timer.start(visible_time)


func _on_level_completed(_data) -> void:
	current_level += 1


func _on_hub_entered() -> void:
	current_level = 1
	EventBus.emit_signal("level_started", "Hub")
