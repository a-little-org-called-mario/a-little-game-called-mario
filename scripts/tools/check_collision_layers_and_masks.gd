# This file is solely used for a GitHub Action and can be ignored for game developers.
# If you want to run this locally, navigate to the root of the project and run
# godot --script scripts/tools/collision_mask_check.gd --quit
# This file will recursively parse every scene (.tscn) in the current directory structure,
# grab every node native to that scene (meaning it will skip nodes that are instanced), 
# and check to see if its properties contain the collision_layer and/or collision_mask properties
# If it does, it will check to see if those properties contain an odd number in the .tscn file.
# If it is an odd number or the setting does not exist (1 is the default setting and doesn't show up),
# it will print out information informing the user of the problems found.
# The GitHub action will manipulate this data to only show the files the submitter has changed
# in their pull request.

extends SceneTree

var type_cache: Dictionary = {}

func _init() -> void:
	var files: Array = list_files_in_directory()
	parse_files(files)
	quit()
	
# Recursively search the current directory and return a file list array
func list_files_in_directory() -> Array:
	var dir_queue: Array = ["res://"]
	var dir: Directory
	var files: Array = []
	var file: String
	
	while file or not dir_queue.empty():
		if file:
			if dir.current_is_dir():
				dir_queue.append("%s/%s" % [dir.get_current_dir(), file])
			elif file.ends_with(".tscn"):
				files.append("%s/%s" % [dir.get_current_dir(), file.get_file()])
		else:
			if dir:
				dir.list_dir_end()
			if dir_queue.empty():
				break
			dir = Directory.new()
			dir.open(dir_queue.pop_front())
			dir.list_dir_begin(true, true)
		file = dir.get_next()
	return files

# Read each file in the files array, parse information needed
func parse_files(files: Array) -> void:
	var header_regex: RegEx = RegEx.new()
	header_regex.compile("^\\[node name=\"(?<name>[^\"]+)\" type=\"(?<type>[^\"]+)\"")
	for file in files:
		var content: String = read_file(file)
		for section in extract_node_sections(content):
			var result: RegExMatch = header_regex.search(section.substr(0, section.find("\n")))
			if not result:
				continue
			search_node(result.get_string("name"), result.get_string("type"), file, section)

# Actually read the file
func read_file(file: String) -> String:
	var full_text: String
	var f: File = File.new()
	var err: int = f.open(file, File.READ)
	if err != OK:
		print("Error reading file %s" % str(f))
	else:
		full_text = f.get_as_text()
	return full_text

# Split the file content into node sections
func extract_node_sections(text: String) -> Array:
	var sections: Array = []
	var from: int = -1
	var idx: int = text.find("[node name=")
	while idx >= 0:
		if from >= 0:
			sections.append(text.substr(from, idx - from - 1))
		from = idx
		idx = text.find("[node name=", idx + 1)
	if from >= 0:
		sections.append(text.substr(from, len(text) - from))
	return sections

# Spin up each node_type and search its property list for collision_mask/layer.
# If found pass the information along to find_bits
func search_node(node_name, node_type, file, section) -> void:
	if node_type in type_cache:
		for domain in type_cache[node_type]:
			find_bits(node_name, node_type, file, domain, section)
		return

	type_cache[node_type] = []

	var script: GDScript = GDScript.new()
	script.set_source_code("func eval():\n\treturn %s.new()" % node_type)
	script.reload()
	
	var evaluator: Object = Reference.new()
	evaluator.set_script(script)
	
	for item in evaluator.eval().get_property_list():
		for domain in ['collision_layer', 'collision_mask']:
			if item['name'] == domain:
				type_cache[node_type].append(domain)
				find_bits(node_name, node_type, file, domain, section)

# Search the section for the collision_domain and find its bit value
# If nothing is found, assume the bit value is 1 which is the default
# Find the modulo of the bit_num. If it isn't 0 we know the bit_num is odd.
# If bit_num is odd, print out information
func find_bits(node_name, node_type, file, collision_domain, section) -> void:
	var bit_num : int = 1
	for line in section.split("\n"):
		if line.begins_with(collision_domain):
			bit_num = line.split(" = ", false, 2)[1].to_int()
			break
	if bit_num % 2 != 0:
		print("|%s|%s|%s|%s is set to %d|" % [file, node_name, node_type, collision_domain, bit_num])
