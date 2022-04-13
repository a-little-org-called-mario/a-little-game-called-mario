extends RichTextLabel

const Util = preload("res://scripts/Util.gd")

var contributor_names : Array = []


func _ready():
	randomize()

	contributor_names = Util.get_contributor_names()

	display_contributors()


func display_contributors():
	var random_contributors = rand_values(contributor_names)

	bbcode_text = "\n[wave amp=100 freq=2]%s\n%s\n%s" % [str(random_contributors[0]).to_upper(),str(random_contributors[1]).to_upper(),str(random_contributors[2]).to_upper()]


func rand_values(arr):
	if arr.size() < 3:
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


func _on_Timer_timeout():
	display_contributors()
