extends Node

onready var inventory: PlayerInventory = owner.inventory if owner is Player else preload("res://scripts/resources/PlayerInventory.tres")

func _ready() -> void:
	EventBus.connect("coin_collected", self, "_on_coin_collected")


func _on_coin_collected(data: Dictionary) -> void:
	var value := 1
	if data.has("value"):
		value = data["value"]
	inventory.coins += value


func _exit_tree() -> void:
	EventBus.disconnect("coin_collected", self, "_on_coin_collected")
