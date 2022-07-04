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
