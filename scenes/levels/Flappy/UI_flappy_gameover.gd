extends CanvasLayer

var inventory = preload("res://scripts/resources/PlayerInventory.tres")

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
