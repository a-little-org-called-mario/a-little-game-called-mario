class Dialog:
	"""
	A single message of a dialog.

	Can have multiple responses the player can choose.
	Can trigger events, give items and change the character sprite.
	It is possible to create branching dialogs with conditions.
	"""
	
	var text: Array
	var choices: Array
	
	var item: String
	var event: String
	var new_sprite: Texture
	
	var condition: Condition
	# If the condition applies to this dialog or if there are two possible branches
	# for each outcome.
	var has_branches := false
	
	# The dialog to execute if the condition is true.
	var True: Reference
	# The dialog to execute if the condition is false.
	var False: Reference
	
	func _init(data) -> void:
		data = data if data else {}
		if data is String:
			text = [data]
			return
		if "condition" in data:
			condition = Condition.new(data.condition)
		if "false" in data:
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
		for data in choice_data:
			choices.append(Choice.new(data))
		item = data.get("item", "")
		event = data.get("event", "")

 
class Condition:
	# The condition is only true if this is the exact occurence
	# this dialog is shown.
	var only_at_occurence: int
	# The condition is only true if the player has this item.
	var required_item: String
	# A custom method that is called to check if the method is true.
	var custom: String
	var inverted: bool
	
	func _init(data: Dictionary) -> void:
		only_at_occurence = data.get("occurence", 0)
		required_item = data.get("has_item", "")
		custom = data.get("custom", "")
		inverted = data.get("inverted", false)


class Choice:
	var text: String
	var condition: Condition
	var dialog: Dialog
	
	func _init(data) -> void:
		if data is String:
			text = data
		elif data is Dictionary:
			text = data.text
			dialog = Dialog.new(data.dialog)
			if "condition" in data:
				condition = Condition.new(data.condition)
