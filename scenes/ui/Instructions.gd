extends "res://scenes/ui/scripts/TranslatedRichTextLabel.gd"


func _input(event):
	if event.is_action_pressed("show_instructions"):
		visible = true
	elif event.is_action_released("show_instructions"):
		visible = false
