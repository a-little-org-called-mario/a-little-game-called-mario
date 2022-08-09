extends BaseMenuButton
class_name RedirectMenuButton

export (String, FILE, "*.tscn") var redirect_scene


func _on_pressed():
	EventBus.emit_signal("change_scene", { "scene": redirect_scene })
