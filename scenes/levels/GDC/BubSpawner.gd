extends Position2D


export var id: String
export (PackedScene) var thing_to_spawn


func _ready() -> void:
	EventBus.connect("big_button_pressed", self, "react")


func react(button_id: String) -> void:
	if button_id != id:
		return
	print("react?")
	var thing = thing_to_spawn.instance()
	add_child(thing)
	thing.max_speed = 50