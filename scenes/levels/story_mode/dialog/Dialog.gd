extends Resource

var text : Array
var choices : Dictionary

func _init(data := {}) -> void:
	var text_data = data.get("text", "")
	if text_data is String:
		text = [text_data]
	else:
		text = text_data
	var choice_data = data.get("choices", [])
	if choice_data is String:
		choices = {choice_data: null}
	elif choice_data is Array:
		for dialog in choice_data:
			choices[dialog.text] = get_script().new(dialog.dialog)
