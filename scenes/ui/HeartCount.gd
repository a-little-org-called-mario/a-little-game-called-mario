extends RichTextLabel

var inventory = preload("res://scripts/resources/PlayerInventory.tres")

func _ready() -> void:
	EventBus.connect("heart_changed", self, "_on_heart_change")
	_update_hearts(inventory.hearts)

func _on_heart_change(_delta: int, total: int) -> void:
	call_deferred("_update_hearts", total)
	

func _update_hearts(total: int) -> void:
	bbcode_text = (
		tr("\n[wave amp=50 freq=2]HEARTS:[rainbow freq=0.5 sat=1 val=20]%s[/rainbow] [/wave]")
		% total
	)
