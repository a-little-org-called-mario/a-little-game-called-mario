extends HBoxContainer
class_name OptionContainer

signal value_changed(value)

export (String) var name_label = "OPTION NAME"
export (NodePath) var value_label_nodepath
export (Dictionary) var value_label_mapping = {}

onready var texture_rect: TextureRect = $TextureRect
onready var option_label: Label = $OptionLabel
onready var option_slider: HSlider = $OptionSlider
onready var value_label: Label = get_node(value_label_nodepath) as Label

func _ready() -> void:
	option_label.text = name_label
	option_slider.connect("focus_entered", self, "_on_focus_entered")
	option_slider.connect("focus_exited", self, "_on_focus_exited")
	option_slider.connect("mouse_entered", self, "_on_focus_entered")
	option_slider.connect("mouse_exited", self, "_on_focus_exited")
	hide_icon()
	
func set_value(value):
	option_slider.value = value
	value_label.text = str(value)

func show_icon():
	texture_rect.modulate.a = 1

func hide_icon():
	texture_rect.modulate.a = 0

func _on_focus_entered():
	show_icon()
	
func _on_focus_exited():
	hide_icon()


func _on_OptionSlider_value_changed(value):
	value_label.text = str(value_label_mapping.get(int(value), int(value)))
	self.emit_signal("value_changed", value)
