# hold player information across scenes
# has to be reset on game restart
extends Resource

export var coins: int
export var hearts: int
export var has_flower: bool
export var has_bus: bool
export var stars: Dictionary

func reset() -> void:
	coins = 0
	hearts = 3
	has_flower = false
	has_bus = false
	stars = {}

func reset_to(inventory: Resource):
	EventBus.emit_signal("heart_changed", inventory.hearts-hearts, inventory.hearts)
	EventBus.emit_signal("coin_collected", {"value": 0, "total": inventory.coins, "type": "coin"})
	coins = inventory.coins
	hearts = inventory.hearts
	has_flower = inventory.has_flower
	has_bus = inventory.has_bus
	stars = inventory.stars
