extends Camera2D
class_name ShakingCamera
onready var _screen_shake: ScreenShake = $ScreenShake

const CameraLeanAmount = preload("res://scripts/CameraLeanAmount.gd")


func _ready():
	EventBus.connect("small_screen_shake", self, "trigger_small_shake")
	EventBus.connect("medium_screen_shake", self, "trigger_medium_shake")
	EventBus.connect("large_screen_shake", self, "trigger_large_shake")
	EventBus.connect("jumping", self, "trigger_small_shake")
	EventBus.connect("enemy_killed", self, "trigger_small_shake")
	EventBus.connect("level_started", self, "return_to_center")
	EventBus.connect("heart_changed", self, "_on_heart_changed")
	position = get_viewport_rect().size / 2


func _process(_delta):
	if Input.is_action_pressed("right"):
		var lean_amount: float = 0
		if CameraLeanAmount.MAX == Settings.camera_lean:
			lean_amount = PI / 64
		elif CameraLeanAmount.MIN == Settings.camera_lean:
			lean_amount = PI / 128
		lean(-lean_amount)
	elif Input.is_action_pressed("left"):
		var lean_amount: float = 0
		if CameraLeanAmount.MAX == Settings.camera_lean:
			lean_amount = PI / 64
		elif CameraLeanAmount.MIN == Settings.camera_lean:
			lean_amount = PI / 128
		lean(lean_amount)
	else:
		lean(0, 0.1)


func lean(radians, speed := 0.05) -> void:
	rotation = lerp(rotation, radians, speed)
	zoom.x = lerp(zoom.x, 1 + radians / 2.0, speed * 2)
	zoom.y = lerp(zoom.y, 1 - radians / 2.0, speed * 2)


func trigger_small_shake() -> void:
	_screen_shake.start(.1, 8, 10, 7)


func trigger_medium_shake() -> void:
	_screen_shake.start(.1, 15, 20, 5)


func trigger_large_shake() -> void:
	_screen_shake.start(.1, 20, 50, 10)


func return_to_center(_data) -> void:
	position = get_viewport_rect().size / 2


func _on_heart_changed(delta: int, _total: int) -> void:
	if delta < 0:
		trigger_medium_shake()
