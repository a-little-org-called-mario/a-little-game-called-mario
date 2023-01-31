extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_BusAttackBox_body_entered")
	
	
func activate(active: bool):
	monitoring = active


func _on_BusAttackBox_body_entered(body : Node2D):
	if body.is_in_group("enemy") and body.has_method("kill"):
		body.kill(self)
