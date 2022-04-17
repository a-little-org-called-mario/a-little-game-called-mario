extends CanvasLayer

var next_scene := "res://scenes/title/TitleScreen.tscn"

onready var animation = $ColorRect/AnimationPlayer

func _ready():
  EventBus.connect("change_scene", self, "_on_change_scene")
  animation.connect("animation_finished", self, "_on_animation_finished")
  
func _on_change_scene(data):
  next_scene = data["scene"]
  animation.play("TransitionOut")
  
func _on_animation_finished(animation_name):
	if animation_name == "TransitionOut":
		get_tree().change_scene(next_scene)
		animation.play("TransitionIn")
