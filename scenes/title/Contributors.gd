extends RichTextLabel

var lines = []

func _ready():
	var file = File.new()
	file.open("res://credits.txt", File.READ)
	
	while not file.eof_reached():
		lines.append(file.get_line())
	
	file.close()
	setup()

func setup():
	var contrib_array = rand_values(lines)
	bbcode_text = "\n[wave amp=100 freq=2]%s\n%s\n%s" % [str(contrib_array[0]).to_upper(),str(contrib_array[1]).to_upper(),str(contrib_array[2]).to_upper()]
	
func rand_values(arr):
	randomize()
	var rand_array = []
	var count = 0
	while count != 3:
		var num = randi() % (arr.size() - 1)
		var rand_value = arr[num]
		if not rand_array.has(rand_value):
			rand_array.append(rand_value)
			count += 1
	return(rand_array)

func _on_Timer_timeout():
	setup()
