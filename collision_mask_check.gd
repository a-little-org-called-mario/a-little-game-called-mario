#!/usr/bin/env -S godot -s
# This file is solely used for a GitHub Action and can be ignored for game developers.
# This file will only run if the command 'awk' and 'godot' are available on your PATH.
# Which means it should work on most Linux and MacOS devices that have Godot installed.
# If you want to run this locally, navigate to the directory that contains this file and run
# godot -s collision_mask_check.gd
# This file will recursively parse every scene (.tscn) in the current directory structure,
# grab every node native to that scene (meaning it will skip nodes that are instanced), 
# and check to see if its properties contain the collision_layer and/or collision_mask properties
# If it does, it will check to see if those properties contain an odd number in the .tscn file.
# If it is an odd number or the setting does not exist (1 is the default setting and doesn't show up)
# This program will print out information informing the user of the problems found.
# The GitHub action will manipulate this data to only show the files the submitter has changed
# in their pull request.

extends SceneTree

func _init() -> void:
	var files : Array = list_files_in_directory()
	parse_files(files)
	quit()
	
# Recursively search the current directory and return a file list array
func list_files_in_directory() -> Array:
	var dir_queue : Array = ["res://"]
	var dir : Object
	var files : Array = []
	var file : String
	
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
func parse_files(files) -> void:
	for file in files:
		var text : Array = read_files(file)
		var lines : Array = text[0].split("\n")
		for line in lines:
			if "type=" in line and "node name" in line:
				var file_name : String = text[1]
				var node_split : Array = line.split('[node name="')
				var split2 : Array = node_split[1].split('"')
				var node_name : String = split2[0]
				var split3 : Array = line.split('type="')
				var split4 : Array = split3[1].split('"')
				var node_type : String = split4[0]
				search_node(node_name, node_type, file, text)
		
# Return an array of text lines and the filename
func read_files(file) -> Array:
	var full_text : String
	var f : Object = File.new()
	var err : int = f.open(file, File.READ)
	if err != OK:
		print("Error reading file %s" % str(f))
	else:
		full_text = f.get_as_text()
	return [full_text,file]

# Spin up each node_type and search its property list for collision_mask/layer.
# If found pass the information along to find_bits
func search_node(node_name, node_type, file, text) -> void:
	var new : String = node_type + ".new()"
	var script : Object = GDScript.new()
	script.set_source_code("func eval():\n\treturn " + new)
	script.reload()
	
	var obj : Object = Reference.new()
	obj.set_script(script)
	
	var node_to_test : Object = obj.eval()
	var prop_list : Array = node_to_test.get_property_list()
	for item in prop_list:
		if item['name'] == 'collision_mask':
			find_bits(node_name, node_type, file, 'collision_mask', text)
		if item['name'] == 'collision_layer':
			find_bits(node_name, node_type, file, 'collision_layer', text)

# Search the parsed text for the collision_domain and find its bit value
# If nothing is found, assume the bit value is 1 which is the default
# Find the modulo of the bit_num. If it isn't 0 we know the bit_num is odd.
# If bit_num is odd, print out information
func find_bits(node_name, node_type, file, collision_domain, text) -> void:
	var split : Array = text[0].split("[node name=")
	for block in split:
		var bit_num : int
		if node_name in block:
			if collision_domain in block:
				var bit : Array = []
				OS.execute("echo", [block, "\"| awk -F \"=\" '/" + collision_domain + "/ {print $2}'\""], true, bit)
				bit_num = int(bit[0].strip_edges())
			else:
				bit_num = 1
		
			if bit_num % 2 != 0:
				if bit_num == 1:
					print("%s in file %s for node %s named %s is set to 1. Please see the wikipage on why we are trying to avoid this and how to resolve it. [LINK TO PAGE]." % [collision_domain, file, node_type, node_name])
				else:
					print("%s in file %s for node %s named %s is set to %s. This is an odd number which means that it contains 1. Please see the wikipage on why we are trying to avoid this and how to resolve it. [LINK TO PAGE]." % [collision_domain, file, node_type, node_name, bit_num])
