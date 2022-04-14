extends CanvasLayer

var inventory = preload("res://scripts/resources/PlayerInventory.tres")

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
