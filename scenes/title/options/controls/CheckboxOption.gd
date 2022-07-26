extends BaseOption
class_name CheckboxOption


func _set_value(value) -> void:
	self.control.pressed = value
	._set_value(value)


func _input(_event: InputEvent) -> void:
	if self.control and self.control.has_focus():
		if Input.is_action_just_pressed("ui_left"):
			self.value = false
		elif Input.is_action_just_pressed("ui_right"):
			self.value = true


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		self.value = not self.value
