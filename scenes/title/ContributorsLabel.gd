extends RichTextLabel

onready var _contributors: Contributors = preload("res://scenes/title/Contributors.gd").new()

func _ready() -> void:
	_update_label()


func _update_label() -> void:
	var lines = _contributors.get_lines_randomized()
	if lines.empty():
		return
	bbcode_text = "\n[wave amp=100 freq=2]%s\n%s\n%s" % [str(lines[0]).to_upper(),str(lines[1]).to_upper(),str(lines[2]).to_upper()]
	

func _on_Timer_timeout() -> void:
	_update_label()
