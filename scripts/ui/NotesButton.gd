extends Button


signal page_changed(pageName)


func _on_focus_entered():
	emit_current_focus()


func emit_current_focus():
	emit_signal("page_changed", text)

