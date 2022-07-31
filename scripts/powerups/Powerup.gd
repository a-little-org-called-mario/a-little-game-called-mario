#Main class for various powerups
#To implement other powerups, simply extend this script
#and implement _on_body_entered to call_deferred("collect", signal_name)
extends Area2D
class_name Powerup

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(_body):
	#In a subclass, use the same code but put the signal name instead of ""
	call_deferred("collect", "")


func collect(signal_name: String, data := {}):
	data["collected"] = true
	EventBus.emit_signal(signal_name, data)
	monitoring = false
	queue_free()
