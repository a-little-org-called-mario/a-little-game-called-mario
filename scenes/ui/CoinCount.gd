extends RichTextLabel

var inventory = preload("res://scripts/resources/PlayerInventory.tres")


func _ready():
	EventBus.connect("coin_collected", self, "_on_coin_collected")
	update_coin_count()


func _on_coin_collected(_data):
	call_deferred("update_coin_count")


func update_coin_count():
	bbcode_text = tr("\n[wave amp=50 freq=2]COINS:[rainbow freq=0.5 sat=1 val=20]%d[/rainbow] [/wave]") % inventory.coins
