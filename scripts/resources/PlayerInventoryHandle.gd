# Attach this as a scene child to your player enable coin collecion
extends Node2D
class_name PlayerInventoryHandle

var inventory = preload("res://scripts/resources/PlayerInventory.tres")

func _ready() -> void:
	if not EventBus.is_connected("game_exit", inventory, "reset"):
		EventBus.connect("game_exit", inventory, "reset")

func change_coins(delta: int) -> bool:
	if delta == 0:
		return true

	if inventory.coins + delta < 0:
		return false

	inventory.coins += delta
	EventBus.emit_signal("coin_collected", {"value": delta, "total": inventory.coins, "type": "coin"})
	return true

# Try to find an inventory on the node + children and change the coins. Returns true when successful.
static func change_coins_on(node: Node2D, coin_delta: int) -> bool:
	# operator 'is' has a bug and causes dependency cycle, use 'as' instead
	if node as PlayerInventoryHandle:
		return node.change_coins(coin_delta)
	
	for child in node.get_children():
		if child as PlayerInventoryHandle:
			return child.change_coins(coin_delta)
	return false
