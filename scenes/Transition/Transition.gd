extends CanvasLayer

onready var animation = $AnimationPlayer

func _ready():
  animation.play("TransitionIn")
  EventBus.connect("level_completed", self, "_on_level_completed")
  EventBus.connect("level_started", self, "_on_level_started")
  
func _on_level_completed(_data):
  yield(get_tree().create_timer(0.2), "timeout")
  animation.play("TransitionOut")

func _on_level_started(_data):
  animation.play("TransitionIn")
