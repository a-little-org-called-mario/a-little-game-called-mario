extends CanvasLayer

onready var animation = $AnimationPlayer

func _ready():
  animation.play("TransitionIn")
  EventBus.connect("level_completed", self, "_on_level_completed")
  EventBus.connect("level_started", self, "_on_level_started")
  
func _on_level_completed(_data):
  animation.play("TransitionOut")

func _on_level_started(_data):
  animation.play("TransitionIn")
