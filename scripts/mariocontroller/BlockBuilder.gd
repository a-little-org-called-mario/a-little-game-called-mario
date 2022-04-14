extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Build"):
		EventBus.emit_signal("build_block", {"player": owner})
