extends ItemList

const FileUtils = preload("res://scripts/FileUtils.gd")

export (String, DIR) var level_directory
export (Texture) var icon
export (Dictionary) var tag_colors

onready var secret: bool = Input.is_action_pressed("secret_button")
onready var levels: Array = (
	FileUtils.get_all_levels_in_dir(level_directory) if secret
	else FileUtils.get_all_first_levels_in_dir(level_directory)
)
onready var last_item_selected: int = 0 if len(levels) else -1


func _ready():
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
		self.set_item_icon(last_item_selected, null)
	self.set_item_icon(index, icon)
	last_item_selected = index


func _on_focus_entered():
	if last_item_selected > -1:
		self.select(last_item_selected)
		self.emit_signal("item_selected", last_item_selected)


func unselect_active_item():
	self.unselect(last_item_selected)
	self.set_item_icon(last_item_selected, null)


func _on_empty_space_selected():
	var idx: int = self.get_item_at_position(get_local_mouse_position())
	self.select(idx)
	self.emit_signal("item_selected", idx)
