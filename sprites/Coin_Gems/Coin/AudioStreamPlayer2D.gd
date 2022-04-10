extends AudioStreamPlayer2D

onready var coin_counter = preload("res://scripts/CoinCounter.tres")


func _ready():
	coin_counter.connect("coin_amount_changed", self, "_on_coin_amount_changed")


func _on_coin_amount_changed(total, difference):
	if difference >= 1:
		play()
