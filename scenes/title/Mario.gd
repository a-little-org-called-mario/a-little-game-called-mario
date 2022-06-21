extends Sprite


func _unhandled_input(event):
	if event.is_action_pressed("click"):
		if get_rect().has_point(to_local(get_global_mouse_position())):
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var num = rng.randi_range(0, 6)
			if (num == 0):
				$Woem.play()
			else:
				$Meow.play()
