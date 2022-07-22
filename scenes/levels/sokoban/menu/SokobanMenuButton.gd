extends TitleMenuButton


func _on_pressed():
	EventBus.emit_signal("level_exited")
