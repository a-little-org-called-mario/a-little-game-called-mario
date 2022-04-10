extends Camera2D
class_name ShakingCamera
onready var _screen_shake: ScreenShake = $ScreenShake


func _ready():
  EventBus.connect("enemy_killed", self, "trigger_small_shake")
  position = get_viewport_rect().size / 2

func _process(_delta):
  if Input.is_action_pressed("right"):
   lean(-PI / 64)
  elif Input.is_action_pressed("left"):
   lean(PI / 64)
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
