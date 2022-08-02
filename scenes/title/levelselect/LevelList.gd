extends ItemList

const FileUtils = preload("res://scripts/FileUtils.gd")

export (String, DIR) var level_directory
export (Texture) var icon
export (Dictionary) var tag_colors

onready var secret: bool = Input.is_action_pressed("secret_button")
var levels: Array = []
var last_item_selected: int = -1


func _ready():
	if secret:
		levels = FileUtils.get_all_levels_in_dir(level_directory)
	else: 
		levels = FileUtils.get_all_first_levels_in_dir(level_directory)
	_set_items(levels, secret)


func _set_items(level_paths: Array, secret: bool = false) -> void:
	self.clear()
	var i = 0
	for level_path in level_paths:
		var level_name: String = FileUtils.get_dir_name(level_path)
		if secret:
			level_name += "/%s" % level_path.rsplit("/", true, 1)[1].replace(".tscn", "")
		self.add_item(level_name)
		var metadata: LevelMetadata = FileUtils.get_level_metadata(level_path)
		if secret:
			metadata.first_level_path = level_path
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
