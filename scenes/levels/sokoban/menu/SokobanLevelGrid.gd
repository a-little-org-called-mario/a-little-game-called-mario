extends GridContainer

export (String, DIR) var sokoban_level_directory
export (PackedScene) var level_button: PackedScene


func _ready():
	var levels := list_sokoban_levels()
	for i in range(1, len(levels)):
		var button := level_button.instance()
		button.text = str(i)
		button.redirect_scene = sokoban_level_directory + '/' + levels[i]
		add_child(button)
	self._focus_first_button()


func _focus_first_button():
	for child in get_children():
		if child is Button:
			child.grab_focus()
			break


func list_sokoban_levels() -> Array:
	var levels := []
	var dir := Directory.new()
	if dir.open(sokoban_level_directory) == OK:
		dir.list_dir_begin(true)
		var filename := dir.get_next()
		while filename != "":
			if !dir.current_is_dir():
				levels.append(filename)
			filename = dir.get_next()
		dir.list_dir_end()
	levels.sort()
	return levels
