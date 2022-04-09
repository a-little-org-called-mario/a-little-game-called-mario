extends Node

var lives = 5
var hearts = []

func _ready():
	EventBus.connect("lives_reduced", self, "_on_lives_reduced")
	
	for heart in self.get_children():
		hearts.append(heart)
	
func _on_lives_reduced(data):
	if data.has("value"):
		var value = data["value"]

		lives -= value
		
		var count = 0;
		for heart in hearts:
			count = count + 1
			if lives < count:
				heart.hide()
			else:
				heart.show()
