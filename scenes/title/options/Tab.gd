extends Control

export var text = "Tab" setget _set_text
onready var texture_rect: TextureRect = $HBoxContainer/TextureRect

func _ready() -> void:
	hide_icon()

func _set_text(new_text):
	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_on_focus_exited")
	connect("mouse_entered", self, "_on_focus_entered")
	connect("mouse_exited", self, "_on_focus_exited")
	text = str(new_text)
	$HBoxContainer/Label.text = str(new_text)

func show_icon():
	texture_rect.modulate.a = 1

func hide_icon():
	texture_rect.modulate.a = 0
	
func selected():
	modulate.v = 1
	show_icon()

func deselected():
	modulate.v = 0.66
	hide_icon()


func _on_focus_entered():
	show_icon()

func _on_focus_exited():
	hide_icon()
