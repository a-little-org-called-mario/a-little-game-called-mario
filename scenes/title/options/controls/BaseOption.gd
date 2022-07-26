extends HBoxContainer
class_name BaseOption

signal value_changed(value)

export (Dictionary) var value_label_mapping := {}
export (NodePath) var control_nodepath
export (NodePath) var value_label_nodepath
export (NodePath) var texture_rect_nodepath

onready var control: Control = get_node_or_null(control_nodepath) as Control
onready var texture_rect: TextureRect = get_node(texture_rect_nodepath) as TextureRect
onready var value_label: Label = get_node(value_label_nodepath) as Label


var value setget _set_value, _get_value


func _ready():
	if control:
		connect("focus_entered", control, "grab_focus")
		connect("focus_exited", control, "release_focus")
		connect("mouse_entered", self, "grab_focus")
		control.connect("focus_entered", self, "show_icon")
		control.connect("focus_exited", self, "hide_icon")
		control.connect("mouse_entered", self, "grab_focus")
	hide_icon()


func show_icon():
	texture_rect.modulate.a = 1


func hide_icon():
	texture_rect.modulate.a = 0


func _set_value(val):
	value = val
	_on_value_changed(val)


func _get_value():
	return value


func _on_value_changed(val):
	value_label.text = str(value_label_mapping.get(val, val))
	self.emit_signal("value_changed", val)
