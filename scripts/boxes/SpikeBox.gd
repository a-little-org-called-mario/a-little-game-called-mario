extends BaseBox


var inventory = preload("res://scripts/resources/PlayerInventory.tres")

func bounce(body: KinematicBody2D):
	on_bounce(body)
	if not body is Player:
		return
	
	audio_meow.play()
	EventBus.emit_signal("heart_changed", {"value": -inventory.hearts})
	
