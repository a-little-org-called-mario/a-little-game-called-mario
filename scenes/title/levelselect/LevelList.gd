extends ItemList

const FileUtils = preload("res://scripts/FileUtils.gd")

export (String, DIR) var level_directory
export (Texture) var icon

onready var levels = FileUtils.get_all_first_levels_in_dir(level_directory)
var last_item_selected = -1


func _ready():
	_set_items(levels)


func _set_items(level_paths: Array) -> void:
	self.clear()
	var i = 0
	for level_path in level_paths:
		self.add_item(FileUtils.get_dir_name(level_path))
		self.set_item_metadata(i, level_path)
		i += 1
	if len(level_paths) > 0:
		self.select(0)
		emit_signal("item_selected", 0)


func _on_item_selected(index):
	if last_item_selected > -1:
		set_item_icon(last_item_selected, null)
	set_item_icon(index, icon)
	last_item_selected = index
