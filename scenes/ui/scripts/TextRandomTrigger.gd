extends TextTrigger

export(float, 0, 1, 0.01) var random_phrase_chance: float = 0.3
export(Array, String) var phrases: Array

onready var original_text: String = text

var idx: int = 0


func _ready():
	randomize()
	phrases.shuffle()


func _on_body_entered(_body):
	if randf() >= random_phrase_chance and not phrases.empty():
		var phrase = phrases[idx]
		idx += 1
		if idx >= phrases.size():
			idx = 0
			phrases.shuffle()
		.set_text(phrase)
	else:
		.set_text(original_text)
	._on_body_entered(_body)
