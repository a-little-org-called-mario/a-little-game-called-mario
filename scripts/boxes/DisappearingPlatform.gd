# Extends the BaseBox to destroy box after walking over it, with a brief timeout
extends BaseBox

export(float) var disappearDelay

func _ready():
	pass

func _on_box_entered(body):
	if body is KinematicBody2D:
		call_deferred("bounce", body)

func bounce(_body):
	disable()
	var timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", self, "queue_free")
	timer.start(disappearDelay)
