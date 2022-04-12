extends GridContainer

const SOKOBAN_LEVEL_DIRECTORY = "res://scenes/sokoban/levels/"


func _ready():
	var levels := list_sokoban_levels()
	var level_button: PackedScene = preload("res://scenes/sokoban/SokobanLevelButton.tscn")
	for i in range(len(levels)):
		var button := level_button.instance()
		button.level = i + 1
		button.level_url = SOKOBAN_LEVEL_DIRECTORY + levels[i]
		add_child(button)


static func list_sokoban_levels() -> Array:
	var levels := []
	var dir := Directory.new()
	if dir.open(SOKOBAN_LEVEL_DIRECTORY) == OK:
		dir.list_dir_begin(true)
		var filename := dir.get_next()
		while filename != "":
			if !dir.current_is_dir():
				levels.append(filename)
			filename = dir.get_next()
		dir.list_dir_end()
	levels.sort()
	return levels
