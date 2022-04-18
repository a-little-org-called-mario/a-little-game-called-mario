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
