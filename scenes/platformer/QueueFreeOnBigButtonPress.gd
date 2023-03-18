extends Node

export var id: String

export (PackedScene) var spawn_on_exit_tree


func _ready() -> void:
	EventBus.connect("big_button_pressed", self, "react")


func react(button_id: String) -> void:
	if button_id != id:
		return
	get_parent().queue_free()


func _on_QueueFreeOnBigButtonPress_tree_exiting():
	var thing_to_spawn = spawn_on_exit_tree.instance()
	thing_to_spawn.position = get_parent().position
	get_parent().call_deferred("add_child", thing_to_spawn)
