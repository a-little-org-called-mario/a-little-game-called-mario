extends ItemList

const FileUtils = preload("res://scripts/FileUtils.gd")

export (String, DIR) var level_directory
export (Texture) var icon
export (Dictionary) var tag_colors

onready var levels = FileUtils.get_all_first_levels_in_dir(level_directory)
var last_item_selected = -1


func _ready():
	_set_items(levels)


func _set_items(level_paths: Array) -> void:
	self.clear()
	var i = 0
	for level_path in level_paths:
		self.add_item(FileUtils.get_dir_name(level_path))
		var metadata = FileUtils.get_level_metadata(level_path)
		self.set_item_metadata(i, metadata)
		i += 1


func set_item_metadata(idx: int, metadata) -> void:
	self.set_item_tooltip(idx, metadata.short_description)
	for tag in metadata.tags:
		self._set_item_tag(idx, tag)
	.set_item_metadata(idx, metadata)


func _set_item_tag(idx: int, tag: String):
	var color = tag_colors.get(tag, tag_colors.get("default"))
	if color:
		self.set_item_custom_fg_color(idx, color)


func _on_item_selected(index):
	if last_item_selected > -1:
		set_item_icon(last_item_selected, null)
	set_item_icon(index, icon)
	last_item_selected = index
