extends RichTextLabel

signal dialogue_completed

export(Array, String) var dialogue: Array = []
export(float) var auto_display_seconds: float = 3.0

var current_string: int = -1


func auto_advance_dialogue():
	if current_string != -1:
		return
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = auto_display_seconds
	timer.connect("timeout", self, "advance_dialogue")
	timer.start()
	advance_dialogue()


func advance_dialogue():
	current_string += 1
	if current_string < dialogue.size():
		bbcode_text = "[center]%s[/center]" % dialogue[current_string].to_upper()
	else:
		bbcode_text = ""
		emit_signal("dialogue_completed")
		queue_free()
