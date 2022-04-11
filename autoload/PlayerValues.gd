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

func get_coins():
	return _coins

func get_hearts():
	return _hearts

func has_flower():
	return _hasFlower

func _on_coin_collected(data):
	var value := 1
	if data.has("value"):
		value = data["value"]
	_coins += value

func _on_heart_change(data):
	var value := 1
	if data.has("value"):
		value = data["value"]
	_hearts += value
	if(_hearts <= 0):
		get_tree().reload_current_scene()

func _on_flower_collected(data):
	if data.has("collected"):
		_hasFlower = data["collected"]
