extends Label

export var secondsUntilDisappearing = 5


func _process(delta: float) -> void:
	if visible:
		secondsUntilDisappearing -= delta
	if secondsUntilDisappearing < 0:
		queue_free()


func reveal() -> void:
	visible = true
