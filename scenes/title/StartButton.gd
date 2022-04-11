extends Button

func _ready():
  # This is so you can use the menu with the keyboard
  grab_focus()

  # Signals can be found here: https://docs.godotengine.org/en/stable/classes/class_basebutton.html
  self.connect("pressed", self, "_on_pressed")
  
func _on_pressed():
  EventBus.emit_signal("change_scene", { "scene": "res://scenes/Main.tscn" })
