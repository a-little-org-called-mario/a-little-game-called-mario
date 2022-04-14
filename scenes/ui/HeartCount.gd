extends RichTextLabel

var inventory = preload("res://scripts/resources/PlayerInventory.tres")

func _ready() -> void:
	EventBus.connect("heart_changed", self, "_on_heart_change")
	_update_hearts()

func _on_heart_change(_data: Dictionary) -> void:
	call_deferred("_update_hearts")
	

func _update_hearts() -> void:
	bbcode_text = (
		"\n[wave amp=50 freq=2]HEARTS:[rainbow freq=0.5 sat=1 val=20]%d[/rainbow][/wave]"
		% inventory.hearts
	)
