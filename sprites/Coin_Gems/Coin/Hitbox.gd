extends Area2D

onready var audio_player = $AudioStreamPlayer2D
onready var animation = $Sprite/AnimationPlayer

func _ready():
  self.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(_body):
  call_deferred("collect")

func collect():
  EventBus.emit_signal("coin_collected", { "value": 1, "type": "gold" })
  audio_player.play()
  animation.play("Collect")
  monitoring = false
  yield(animation, "animation_finished")
  queue_free()
