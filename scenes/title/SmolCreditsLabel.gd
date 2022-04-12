extends Label

onready var animation = $AnimationPlayer

func _ready():
  GitHubApi.connect("contributors_loaded", self, "_on_contributors_loaded")
  
func _on_contributors_loaded(_names):
  animation.play("Appear")
