extends GridContainer

const SOKOBAN_LEVEL_DIRECTORY = "res://scenes/sokoban/levels/"
export (PackedScene) var level_button: PackedScene


func _ready():
	var levels := list_sokoban_levels()
	for i in range(len(levels)):
		var button := level_button.instance()
		button.text = str(i+1)
		button.redirect_scene = SOKOBAN_LEVEL_DIRECTORY + levels[i]
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
