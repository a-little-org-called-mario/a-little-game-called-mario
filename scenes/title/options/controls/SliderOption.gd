extends BaseOption
class_name SliderOption


func _set_value(value):
	self.control.value = value
	._set_value(value)
