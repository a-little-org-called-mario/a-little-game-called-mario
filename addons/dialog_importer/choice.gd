extends Resource

export var text: String
export var condition: Resource
export var dialog: Resource

const Condition = preload("res://addons/dialog_importer/condition.gd")

func _init(data = "") -> void:
	if data is String:
		text = data
	elif data is Dictionary:
		text = data.text
		dialog = load("res://addons/dialog_importer/dialog.gd").new(data.dialog)
		if "condition" in data:
			condition = Condition.new(data.condition)
