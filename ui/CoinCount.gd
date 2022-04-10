extends RichTextLabel

var count := 0


func _ready():
	EventBus.connect("coin_collected", self, "_on_coin_collected")
	update_coin_count()

func _on_coin_collected(data):
	var value := 1
	if data.has("value"):
		value = data["value"]
	count += value
	update_coin_count()

func update_coin_count():
	bbcode_text = tr("UI_COINS") % count

