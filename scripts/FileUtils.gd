# Returns a list of non-hidden files inside a given directory.
static func list_dir(path: String) -> Array:
	var dir := Directory.new()
	if dir.open(path) != OK:
		return []
	if dir.list_dir_begin(true, true) != OK:
		return []
	var files := []
	var file := dir.get_next()
	while file:
		files.append(path.plus_file(file))
		file = dir.get_next()
	return files


# Returns the content of a file as a json object.
static func as_json(path: String) -> Dictionary:
	var file := File.new()
	if file.open(path, File.READ) != OK:
		return {}
	var text := file.get_as_text()
	file.close()
	return parse_json(text)


static func _getFilePathsFromImport(path: String, extension1: String, extension2: String = "null"):
	var dir := Directory.new()
	var foundFiles := []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var filename := dir.get_next()
		while filename != "":
			if (
				filename != "."
				and filename != ".."
				and !dir.current_is_dir()
				and (
					filename.ends_with(extension1 + ".import")
					or filename.ends_with(extension2 + ".import")
				)
			):
				foundFiles.append(("%s/%s" % [path, filename]).rstrip(".import"))
			filename = dir.get_next()
		dir.list_dir_end()
	else:
		return false

	if len(foundFiles) < 1:
		return false

	else:
		return foundFiles


static func get_dir_name(levelPath: String) -> String:
	var regex = RegEx.new()
	regex.compile(".*\/(.*)\/[^\/]+.tscn")
	return regex.search(levelPath).get_string(1)


static func get_level_metadata(level_path: String) -> LevelMetadata:
	var metadata_path = level_path.rsplit("/", true, 1)[0] + "/metadata/metadata.tres"
	if ResourceLoader.exists(metadata_path):
		var metadata = ResourceLoader.load(metadata_path) as LevelMetadata
		if not metadata.first_level_path:
			metadata.first_level_path = level_path
		return metadata
	return LevelMetadata.new(level_path)


static func get_all_first_levels_in_dir(path: String) -> Array:
	var levels := []
	var dir := Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var filename := dir.get_next()
		while filename != "":
			if filename != "." and filename != ".." and dir.current_is_dir():
				var level := get_first_level_in_dir("%s/%s" % [path, filename])
				if len(level) > 0:
					levels.append(level)
			filename = dir.get_next()
		dir.list_dir_end()

	levels.sort()
	return levels


static func get_first_level_in_dir(path: String) -> String:
	var dir := Directory.new()
	var levels := []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var filename := dir.get_next()
		while filename != "":
			if (
				filename != "."
				and filename != ".."
				and !dir.current_is_dir()
				and filename.ends_with(".tscn")
			):
				levels.append("%s/%s" % [path, filename])
			filename = dir.get_next()
		dir.list_dir_end()
	# note[apple]: Directory order is not the same on all platforms. On Linux, for some reason,
	# not sorting the list means that the last level gets returned first
	if len(levels) > 0:
		levels.sort()
		return levels[0]
	else:
		return ""


static func get_all_levels_in_dir(path: String) -> Array:
	var result := []
	var levels_dir := Directory.new()
	if levels_dir.open(path) != OK:
		return result
	levels_dir.list_dir_begin()
	var dir := levels_dir.get_next()
	while dir != "":
		if dir != "." and dir != ".." and levels_dir.current_is_dir():
			var levels = list_dir("%s/%s" % [path, dir])
			for level in levels:
				if level.ends_with(".tscn"):
					result.append(level)
		dir = levels_dir.get_next()
	levels_dir.list_dir_end()
	result.sort()
	return result
