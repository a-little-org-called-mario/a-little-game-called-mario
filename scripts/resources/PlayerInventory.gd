# hold player information across scenes
# has to be reset on game restart
extends Resource
class_name PlayerInventory

export var coins: int
export var hearts: int
export var has_flower: bool
export (int, 0, 999) var flower_amount: int = 0 setget set_flower_amount
export var has_bus: bool
export var stars: Dictionary


func _init():
	EventBus.connect("fire_flower_collected", self, "_on_fireflower_collected")
	EventBus.connect("shot", self, "_on_shot")


func duplicate(subresources: bool = false):
	var dup = .duplicate(subresources)
	EventBus.disconnect("fire_flower_collected", dup, "_on_fireflower_collected")
	EventBus.disconnect("shot", dup, "_on_shot")
	return dup


func reset() -> void:
	coins = 0
	hearts = 3
	flower_amount = 0
	has_flower = false
	has_bus = false
	stars = {}


func reset_to(inventory: Resource):
	EventBus.emit_signal("heart_changed", inventory.hearts-hearts, inventory.hearts)
	EventBus.emit_signal("coin_collected", {"value": 0, "total": inventory.coins, "type": "coin"})
	coins = inventory.coins
	hearts = inventory.hearts
	self.flower_amount = inventory.flower_amount
	if flower_amount > 0:
		EventBus.emit_signal("fire_flower_collected", {
			"amount": inventory.flower_amount
		})
	has_flower = inventory.has_flower
	has_bus = inventory.has_bus
	stars = inventory.stars


func _on_fireflower_collected(data := {}) -> void:
	flower_amount = int(data.get("amount", 100))
	has_flower = true


func _on_shot() -> void:
	if has_flower:
		self.flower_amount -= 1


func set_flower_amount(value: int) -> void:
	flower_amount = value
	if flower_amount <= 0:
		has_flower = false
		EventBus.emit_signal("fire_flower_ended")
