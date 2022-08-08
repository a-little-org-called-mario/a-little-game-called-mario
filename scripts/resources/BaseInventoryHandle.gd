extends Node2D
class_name BaseInventoryHandle

var inventory: PlayerInventory = preload("res://scripts/resources/PlayerInventory.tres")

func _ready() -> void:
	if not EventBus.is_connected("game_exit", inventory, "reset"):
		EventBus.connect("game_exit", inventory, "reset")
