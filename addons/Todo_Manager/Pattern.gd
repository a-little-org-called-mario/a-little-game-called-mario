tool
extends HBoxContainer

var text : String setget set_text
var disabled : bool
var index : int

onready var line_edit := $LineEdit as LineEdit
onready var remove_button := $RemoveButton as Button

func _ready() -> void:
	line_edit.text = text
	remove_button.disabled = disabled


func set_text(value: String) -> void:
	text = value
	if line_edit:
		line_edit.text = value
