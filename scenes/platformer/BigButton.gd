extends StaticBody2D

export var id: String


func press(_body) -> void:
	$AnimationPlayer.play("Press")


func actual_press() -> void:
	EventBus.emit_signal("small_screen_shake")
	EventBus.emit_signal("big_button_pressed", id)
