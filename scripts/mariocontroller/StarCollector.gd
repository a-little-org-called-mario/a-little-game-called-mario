extends Node

onready var player : Player = owner

func _ready() -> void:
	EventBus.connect("star_collected", self, "_on_star_collected")


func _on_star_collected(data: Dictionary) -> void:
	if data.has("name"):
		player.inventory.stars[data["name"]] = true;

func _exit_tree():
	EventBus.disconnect("star_collected", self, "_on_star_collected")
