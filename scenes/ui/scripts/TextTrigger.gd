class_name TextTrigger
extends Area2D

export var text = "some text" setget set_text


func _ready():
	$TextPanel.visible = false
	self.connect("body_entered", self, "_on_body_entered")
	self.connect("body_exited", self, "_on_body_exited")


func _on_body_entered(_body):
	if not _body.is_in_group("Player"):
		return
	$TextPanel.visible = true


func _on_body_exited(_body):
	if not _body.is_in_group("Player"):
		return
	$TextPanel.visible = false


func set_text(t):
	text = t
	$TextPanel/Panel/Label.text = tr(text)
