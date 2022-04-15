extends Node

export var id: String


func _ready() -> void:
	EventBus.connect("big_button_pressed", self, "react")


func react(button_id: String) -> void:
	if button_id != id:
		return
	get_parent().queue_free()
