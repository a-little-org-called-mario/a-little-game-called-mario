# hold player information across scenes
# has to be reset on game restart
extends Resource
class_name PlayerInventory

const MAX_FLOWER: int = 5

export var coins: int
export var hearts: int setget set_hearts
export (int, 13, 39, 1) var max_hearts: int = 26
export var has_flower: bool
export (int, 0, 5) var flower_amount: int = MAX_FLOWER setget set_flower_amount
export var has_bus: bool
export var stars: Dictionary


func _init():
	EventBus.connect("fire_flower_collected", self, "_on_fireflower_collected")
	EventBus.connect("shot", self, "_on_shot")
	EventBus.connect("fire_flower_refilled", self, "_on_fire_flower_refilled")


func duplicate(subresources: bool = false):
	var dup = .duplicate(subresources)
	EventBus.disconnect("fire_flower_collected", dup, "_on_fireflower_collected")
	EventBus.disconnect("shot", dup, "_on_shot")
	EventBus.disconnect("fire_flower_refilled", dup, "_on_fire_flower_refilled")
	return dup


func reset() -> void:
	coins = 0
	self.hearts = 3
	self.flower_amount = MAX_FLOWER
	has_flower = false
	has_bus = false
	stars = {}


func reset_to(inventory: PlayerInventory):
	EventBus.emit_signal("heart_changed", inventory.hearts-hearts, inventory.hearts)
	EventBus.emit_signal("coin_collected", {"value": 0, "total": inventory.coins, "type": "coin"})
	coins = inventory.coins
	self.max_hearts = inventory.max_hearts
	self.hearts = inventory.hearts
	self.flower_amount = inventory.flower_amount
	has_flower = inventory.has_flower
	has_bus = inventory.has_bus
	stars = inventory.stars


func _on_fireflower_collected(data := {}) -> void:
	self.flower_amount = int(data.get("amount", MAX_FLOWER))
	has_flower = true


func _on_fire_flower_refilled(amount: int) -> void:
	self.flower_amount += amount


func _on_shot() -> void:
	if has_flower:
		self.flower_amount -= 1


func set_flower_amount(value: int) -> void:
	flower_amount = clamp(value, 0, MAX_FLOWER)
	EventBus.emit_signal("fire_flower_changed", flower_amount)


func set_hearts(value: int) -> void:
	hearts = clamp(value, 0, self.max_hearts)
