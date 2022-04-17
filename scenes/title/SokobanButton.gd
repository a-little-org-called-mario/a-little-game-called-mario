extends Button

var corn_icon = preload("res://sprites/corncob.png")


func _ready():

	# Signals can be found here: https://docs.godotengine.org/en/stable/classes/class_basebutton.html
	self.connect("mouse_entered", self, "grab_focus")
	self.connect("pressed", self, "_on_pressed")
	self.connect("focus_entered", self, "_on_focus_entered")
	self.connect("focus_exited", self, "_on_focus_exited")


func _on_pressed():
	EventBus.emit_signal("change_scene", {"scene": "res://scenes/sokoban/SokobanMain.tscn"})


func _on_focus_entered():
	self.icon = corn_icon


func _on_focus_exited():
	self.icon = null
