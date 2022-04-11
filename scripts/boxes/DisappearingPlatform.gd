# Extends the BaseBox to destroy box after walking over it, with a brief timeout
extends "res://scripts/boxes/BaseBox.gd"

export(float) var disappearDelay

func _ready():
	pass

func _on_box_entered(body):
	if body is KinematicBody2D:
		call_deferred("bounce")

func bounce():
	.on_bounce()
	disable()
	var timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", self, "queue_free")
	timer.start(disappearDelay)
