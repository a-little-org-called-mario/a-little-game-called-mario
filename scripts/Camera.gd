extends Camera2D
class_name ShakingCamera

onready var _screen_shake: ScreenShake = $ScreenShake


func trigger_small_shake() -> void:
	_screen_shake.start(.1, 8, 10, 7)


func trigger_medium_shake() -> void:
	_screen_shake.start(.1, 15, 20, 5)


func trigger_large_shake() -> void:
	_screen_shake.start(.1, 20, 50, 10)
