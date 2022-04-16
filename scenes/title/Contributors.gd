extends Object
class_name Contributors

var text: String
var lines: Array

func get_text() -> String:
	if not text:
		_load()
	return text


func get_lines() -> Array:
	if not lines:
		_load()
	return lines


func get_lines_randomized() -> Array:
	return _rand_values(get_lines())


func _load() -> void:
	# Credits file is generated at build time - use placeholder string if in editor
	if OS.has_feature("editor"):
		text = "Mario Mario\nLuigi Mario\nBaby Mario"
		lines = text.split("\n")
		return

	randomize()

	var file = File.new()
	var err = file.open("res://credits.txt", File.READ)
	if err != OK:
		lines = []
		print("Couldn't load credits.txt. The file might be missing.")
		return
	
	text = file.get_as_text()
	lines = text.split("\n")
	file.close()

# Randomize the provided array
func _rand_values(arr: Array) -> Array:
	if arr.size() <= 3:
		return arr
	var rand_array = []
	var count = 0
	while count != 3:
		var num = randi() % (arr.size() - 1)
		var rand_value = arr[num]
		if not rand_array.has(rand_value):
			rand_array.append(rand_value)
			count += 1
	return rand_array
