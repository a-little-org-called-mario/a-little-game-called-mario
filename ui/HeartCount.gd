extends RichTextLabel

var count := 3


func _ready():
	EventBus.connect("heart_changed", self, "_on_heart_change")


func _on_heart_change(data):
	var value := 1
	if data.has("value"):
		value = data["value"]

	count += value
	bbcode_text = (
		"\n[wave amp=50 freq=2]HEARTS:[rainbow freq=0.5 sat=1 val=20]%d[/rainbow][/wave]"
		% count
	)
