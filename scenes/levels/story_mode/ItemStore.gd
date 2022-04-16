var _items : Dictionary

const FileUtils = preload("res://scripts/FileUtils.gd")

func _init() -> void:
	for item in FileUtils.list_dir("res://scenes/levels/story_mode/items"):
		_items[item.get_file().get_basename()] = load(item)


func _get(property: String):
	return _items.get(property)
