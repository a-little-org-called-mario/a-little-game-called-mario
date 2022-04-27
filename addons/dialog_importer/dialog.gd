extends Resource

"""
A single message of a dialog.

Can have multiple responses the player can choose.
Can trigger events, give items and change the character sprite.
It is possible to create branching dialogs with conditions.
"""

export var text: Array
export var choices: Array
export var next: Resource

export var character: String
export var item: String
export var event: String

# The dialog to jump to.
export var goto: String
# The label that can be used with goto.
export var label: String

export var condition: Resource
# If the condition applies to this dialog or if there are two possible branches
# for each outcome.
export var has_branches := false

# The dialog to execute if the condition is true.
export var True: Resource
# The dialog to execute if the condition is false.
export var False: Resource

const Condition = preload("res://addons/dialog_importer/condition.gd")
const Choice = preload("res://addons/dialog_importer/choice.gd")

func _init(data = {}) -> void:
	if data is String:
		text = [data]
		return
	elif data is Array:
		var old_data = data
		data = data.pop_front()
		var last = self
		for dialog_data in old_data:
			var dialog = get_script().new(dialog_data)
			last.next = dialog
			last = dialog
	if "goto" in data:
		goto = data.goto
		return
	if "condition" in data:
		condition = Condition.new(data.condition)
	if "false" in data:
		has_branches = true
		True = get_script().new(data.get("true"))
		False = get_script().new(data.get("false"))
		return
	if "next" in data:
		next = get_script().new(data.next)
	var text_data = data.get("text", "")
	if text_data is String:
		text = [text_data]
	else:
		text = text_data
	var choice_data = data.get("choices", [])
	for choice in choice_data:
		choices.append(Choice.new(choice))
	item = data.get("item", "")
	event = data.get("event", "")
	label = data.get("label", "")
	character = data.get("character", "")
