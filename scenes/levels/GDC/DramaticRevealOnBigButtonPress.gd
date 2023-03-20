extends Node

export var id: String

export (NodePath) var hide_on_reveal


func _ready() -> void:
	EventBus.connect("big_button_play_on_press_finished", self, "react")


func react(button_id: String) -> void:
	if button_id != id:
		return
	get_parent().show()
	$AudioStreamPlayer2D.play()

	if hide_on_reveal:
		get_node(hide_on_reveal).hide()

		if get_node(hide_on_reveal).get_node_or_null("CollisionShape2D"):
			get_node(hide_on_reveal).get_node("CollisionShape2D").disabled = true