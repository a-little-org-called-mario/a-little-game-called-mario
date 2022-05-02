tool
extends Area2D


var inventory = preload("res://scripts/resources/PlayerInventory.tres")

export var setting = "heart"
export var resetValue = 3


func _ready():
	self.connect("body_entered", self, "_body_entered")


func _process(delta):
	if setting == "heart":
		$Line2D.modulate = Color(1, 0.14, 0.28, 0.5)
	elif setting == "coin":
		$Line2D.modulate = Color(1, 0.9, 0.07, 0.5)


func _body_entered(body):
	if setting == "heart":
		set_hearts(body)
	elif setting == "coin":
		set_coins(body)


func set_hearts(body):
	while inventory.hearts < resetValue:
		HeartInventoryHandle.change_hearts_on(body, 1)
	while inventory.hearts > resetValue:
		HeartInventoryHandle.change_hearts_on(body, -1)


func set_coins(body):
	while inventory.coins < resetValue:
		CoinInventoryHandle.change_coins_on(body, 1)
	while inventory.coins > resetValue:
		CoinInventoryHandle.change_coins_on(body, -1)

