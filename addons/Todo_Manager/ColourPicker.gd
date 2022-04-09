tool
extends HBoxContainer

var colour : Color
var title : String setget set_title
var index : int

onready var colour_picker := $TODOColourPickerButton

func _ready() -> void:
	$TODOColourPickerButton.color = colour
	$Label.text = title

func set_title(value: String) -> void:
	title = value
	$Label.text = value 
