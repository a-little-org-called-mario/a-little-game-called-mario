extends Sprite

func _ready():
	var dict420:Dictionary = OS.get_datetime()
	if not(dict420.get("month") == 4 and dict420.get("day") == 20):
		visible = false
		get_node("Blunt Fire").enabled = false
		get_node("Blunt Fire/Blunt Smoke").emitting = false
