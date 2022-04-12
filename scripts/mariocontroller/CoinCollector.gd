extends Node


onready var player : Player = owner


func _ready() -> void:
	EventBus.connect("coin_collected", self, "_on_coin_collected")


func _on_coin_collected(data: Dictionary) -> void:
	var value := 1
	if data.has("value"):
		value = data["value"]
	player.coins += value
