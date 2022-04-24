extends Button
class_name CheatMenuButton

export (String) var cheat_name
export (bool) var focused_by_default = false


var selected_icon = self.icon



signal toggle_cheat(name)


func _ready():
	# Signals can be found here: https://docs.godotengine.org/en/stable/classes/class_basebutton.html
	self.connect("mouse_entered", self, "grab_focus")
	self.connect("pressed", self, "_on_pressed")
	self.connect("focus_entered", self, "_on_focus_entered")
	self.connect("focus_exited", self, "_on_focus_exited")
	
	self.icon = null
	
	self.pressed = !CheatsInfo.enabled_cheats.has(cheat_name)

	if focused_by_default:
		grab_focus()


func _on_pressed(): #It feels wrong that I use the pressed signal to send another signal to a node to activate a cheat, but idk if there's a better way
	$ActivateCode.play()
	CheatsInfo.toggle_cheat(cheat_name)


func _on_focus_entered():
	icon = selected_icon


func _on_focus_exited():
	icon = null
