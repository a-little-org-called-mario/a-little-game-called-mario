extends RichTextLabel

export var localization_key = "TRANSLATE_ME"

func _ready():
	bbcode_text = tr(localization_key)
