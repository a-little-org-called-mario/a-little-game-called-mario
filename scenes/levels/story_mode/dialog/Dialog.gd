var text: Array
var choices := {OK = null}
var item: String
var event: String
var new_sprite: Texture

var has_branches := false
var has_condition := false
var only_at_occurence := 0
var True
var False
var required_item

func _init(data) -> void:
	data = data if data else {}
	if data is String:
		text = [data]
		return
	if "condition" in data:
		has_condition = true
		var condition_data = data.condition
		required_item = condition_data.get("has_item", "")
		only_at_occurence = condition_data.get("occurence", 0)
	if "true" in data or "false" in data:
		has_branches = true
		True = get_script().new(data.get("true"))
		False = get_script().new(data.get("false"))
		return
	if "set_sprite" in data:
		new_sprite = load("res://sprites/%s.png" % data.set_sprite)
	var text_data = data.get("text", "")
	if text_data is String:
		text = [text_data]
	else:
		text = text_data
	var choice_data = data.get("choices", [])
	if choice_data is String:
		choices = {choice_data: null}
	elif choice_data is Array:
		choices = {}
		for dialog in choice_data:
			if dialog is String:
				choices[dialog] = null
			else:
				choices[dialog.text] = get_script().new(dialog.dialog)
	item = data.get("item", "")
	event = data.get("event", "")
