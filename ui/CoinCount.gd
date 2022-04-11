extends RichTextLabel

func _ready():
	EventBus.connect("coin_collected", self, "_on_coin_collected")
	update_coin_count()

func _on_coin_collected(_data):
	update_coin_count()

func update_coin_count():
	bbcode_text = tr("UI_COINS") % PlayerValues.get_coins()

