extends Area2D

var triggered = false
var follow_scene = preload("res://scenes/CameraFollow.tscn")

func _ready():
	self.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(_body):
	if triggered:
		return

	if not _body.is_in_group("Player"):
		return

	triggered = true

	get_node("..").call_deferred("add_child", follow_scene.instance())
