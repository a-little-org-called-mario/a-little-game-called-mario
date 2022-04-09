extends RichTextLabel

var count := 0

func _ready():
  EventBus.connect("coin_collected", self, "_on_coin_collected")
  
func _on_coin_collected(data):
  var value := 1
  if data.has("value"):
    value = data["value"]

  count += value
  bbcode_text = "\n[wave amp=50 freq=2]COINS:[rainbow freq=0.5 sat=1 val=20]%d[/rainbow][/wave]" % count
