extends TouchScreenButton

export(Array, String) var actions: Array = []

func _on_pressed():
	for action in actions:
		Input.action_press(action)

func _on_released():
	for action in actions:
		Input.action_release(action)
