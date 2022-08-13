extends RedirectMenuButton

func _on_pressed():
	EventBus.emit_signal("level_changed", load(self.redirect_scene))
