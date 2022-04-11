#FireFlower sprite by Jacob Posten (Harper's brother)
extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(_body) -> void:
	call_deferred("collect")

func collect() -> void:
	EventBus.emit_signal("fire_flower_collected", {"collected": true})
	monitoring = false
	queue_free()
