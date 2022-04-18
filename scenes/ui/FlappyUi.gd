extends CanvasLayer

func _ready() -> void:
	EventBus.connect("level_started", self, "_on_level_started")


func _on_level_started(_data) -> void:
	# if we started as a level, we already have an UI
	queue_free()
