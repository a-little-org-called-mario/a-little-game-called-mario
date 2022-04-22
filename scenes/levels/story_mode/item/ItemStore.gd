var _items : Dictionary

const FileUtils = preload("res://scripts/FileUtils.gd")

func _init(dir: String) -> void:
	for item in FileUtils.list_dir(dir):
		if item.ends_with(".tres"):
			_items[item.get_file().get_basename()] = load(item.replace(".import", ""))


func _get(property: String):
	return _items.get(property)
