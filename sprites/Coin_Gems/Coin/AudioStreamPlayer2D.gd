extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  EventBus.connect("coin_collected", self, "_on_coin_collected")
  
func _on_coin_collected():
  play()
