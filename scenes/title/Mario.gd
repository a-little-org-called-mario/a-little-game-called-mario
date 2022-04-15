extends Sprite


func _unhandled_input(event):
	if event.is_action_pressed("click"):
		if get_rect().has_point(to_local(get_global_mouse_position())):
			$Meow.play()
