extends ItemList

const FileUtils = preload("res://scripts/FileUtils.gd")

export (String, DIR) var level_directory


func _ready():
	var levels = FileUtils.get_all_first_levels_in_dir(level_directory)
	var i = 0
	for level_path in levels:
		self.add_item(FileUtils.get_dir_name(level_path))
		self.set_item_metadata(i, level_path)
		i += 1
	if len(levels) > 0:
		self.select(0)
