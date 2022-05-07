extends Area2D


export var limitID = 0


func _process(delta):
	for i in get_overlapping_bodies():
		if i is Player:
			EventBus.emit_signal("cameraL_enter_set_area", limitID)
