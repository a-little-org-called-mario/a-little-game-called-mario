extends Control

var inventory := preload("res://scripts/resources/PlayerInventory.tres")

onready var coin_spin_box := $CoinSpinBox
onready var heart_spin_box := $HeartSpinBox


# Called when the node enters the scene tree for the first time.
func _ready():
	coin_spin_box.value = inventory.coins
	heart_spin_box.value = inventory.hearts
	
	
func set_coins(value):
	EventBus.emit_signal("coin_collected", {"value": 0, "total": inventory.coins, "type": "coin"})
	inventory.coins = value
	
	
func set_hearts(value):
	EventBus.emit_signal("heart_changed", value-inventory.hearts, value)
	inventory.hearts = value


func _on_CoinSpinBox_value_changed(value):
	set_coins(value)


func _on_HeartSpinBox_value_changed(value):
	set_hearts(value)
