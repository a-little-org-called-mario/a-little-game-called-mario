extends StaticBody2D

export var id: String

export (AudioStream) var play_on_press

var pressed = false


func press(_body) -> void:
	$AnimationPlayer.play("Press")

	if play_on_press and not pressed:
		$PlayOnPress.stream = play_on_press
		$PlayOnPress.play()
		EventBus.emit_signal("bgm_changed", {"playing": false})

	
	pressed = true


func actual_press() -> void:
	EventBus.emit_signal("small_screen_shake")
	EventBus.emit_signal("big_button_pressed", id)


func _on_PlayOnPress_finished():
	EventBus.emit_signal("big_button_play_on_press_finished", id)