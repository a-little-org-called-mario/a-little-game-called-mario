extends Button
class_name TitleMenuButton

export (String, FILE, "*.tscn") var redirect_scene
export (bool) var focused_by_default = false


var selected_icon = self.icon


func _ready():
	# Signals can be found here: https://docs.godotengine.org/en/stable/classes/class_basebutton.html
	self.connect("mouse_entered", self, "grab_focus")
	self.connect("pressed", self, "_on_pressed")
	self.connect("focus_entered", self, "_on_focus_entered")
	self.connect("focus_exited", self, "_on_focus_exited")
	
	self.icon = null

	if focused_by_default:
		grab_focus()


func _on_pressed():
	EventBus.emit_signal("change_scene", { "scene": redirect_scene })


func _on_focus_entered():
	icon = selected_icon


func _on_focus_exited():
	icon = null
