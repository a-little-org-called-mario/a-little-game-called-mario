extends RichTextLabel

onready var coin_counter = preload("res://scripts/CoinCounter.tres")


func _ready():
	coin_counter.connect("coin_amount_changed", self, "_on_coin_amount_changed")
	bbcode_text = (
		"\n[wave amp=50 freq=2]COINS:[rainbow freq=0.5 sat=1 val=20]%d[/rainbow][/wave]"
		% coin_counter.count
	)


func _on_coin_amount_changed(total, _difference):
	bbcode_text = (
		"\n[wave amp=50 freq=2]COINS:[rainbow freq=0.5 sat=1 val=20]%d[/rainbow][/wave]"
		% total
	)
