# Keeps player values that should be globally available
# Use signals to change values, don't do it directly
extends Node

var _coins: int
var _hearts: int = 3
var _hasFlower: bool

func _ready():
	EventBus.connect("coin_collected", self, "_on_coin_collected")
	EventBus.connect("heart_changed", self, "_on_heart_change")
	EventBus.connect("fire_flower_collected", self, "_on_flower_collected")

func get_coins() -> int:
	return _coins

func get_hearts() -> int:
	return _hearts

func has_flower() -> bool:
	return _hasFlower

func _on_coin_collected(data) -> void:
	var value := 1
	if data.has("value"):
		value = data["value"]
	_coins += value

func _on_heart_change(data) -> void:
	var value := 1
	if data.has("value"):
		value = data["value"]
	_hearts += value

func _on_flower_collected(data) -> void:
	if data.has("collected"):
		_hasFlower = data["collected"]
