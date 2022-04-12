extends Label

func _ready():
	var file = File.new()
	file.open("res://credits.txt", File.READ)
	text = file.get_as_text().replace("\n", " ")
