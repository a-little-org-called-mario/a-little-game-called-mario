#!/usr/bin/env -S godot -s
extends SceneTree

var files = []

func _init():
	list_files_in_directory()
	parse_files()
	quit()
	
func list_files_in_directory():
	var dir_queue = ["res://"]
	var dir 
	var file
	
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

func parse_files():
	for file in files:
		var text = read_files(file)
		var lines = text[0].split("\n")
		for line in lines:
			if "type=" in line and "node name" in line:
				var split1 = line.split('type="')
				var split2 = split1[1].split('"')
				search_node(split2[0],text[1])
		

func read_files(file):
	var full_text
	var f = File.new()
	var err = f.open(file, File.READ)
	if err != OK:
		print("Error reading file %s" % str(f))
	else:
		full_text = f.get_as_text()
	return [full_text,file]

func search_node(node_name, file):
	var new = node_name + ".new()"
	var script = GDScript.new()
	script.set_source_code("func eval():\n\treturn " + new)
	script.reload()
	
	var obj = Reference.new()
	obj.set_script(script)
	
	var node_to_test = obj.eval()
	var what = node_to_test.get_property_list()
	for item in what:
		if item['name'] == 'collision_mask':
			#print("found collision_mask on node %s in file %s" % [node_name, file])
			find_bits(node_name, file, 'collision_mask')
		if item['name'] == 'collision_layer':
			#print("found collision_layer on node %s in file %s" % [node_name,file])
			find_bits(node_name, file, 'collision_layer')
			
func find_bits(node_name, file, collision_domain):
	var text = read_files(file)
	var node_split = text[0].split("[node name=")
	for block in node_split:
		var bit_num
		if node_name in block:
			if collision_domain in block:
				var bit = []
				OS.execute("echo", [block, "\"| awk -F \"=\" '/" + collision_domain + "/ {print $2}'\""], true, bit)
				bit_num = int(bit[0].strip_edges())
			else:
				bit_num = 1
		
			if bit_num % 2 != 0:
				if bit_num == 1:
					print("%s in file %s for node %s is set to 1" % [collision_domain, file, node_name])
				else:
					print("%s in file %s for node %s set to %s. This is an odd number which means that it contains 1." % [collision_domain, file, node_name, bit_num])
