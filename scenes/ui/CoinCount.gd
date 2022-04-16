extends RichTextLabel

var inventory = preload("res://scripts/resources/PlayerInventory.tres")

const FORMAT: String = "[right][wave amp=50 freq=2]%s[rainbow freq=0.5 sat=1 val=20]%d[/rainbow][/wave][/right]"


func _ready():
	EventBus.connect("coin_collected", self, "_on_coin_collected")
	update_coin_count()


func _on_coin_collected(_data):
	call_deferred("update_coin_count")


func update_coin_count():
	bbcode_text = FORMAT % [tr("COINS:"), inventory.coins]
