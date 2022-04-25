class_name TrackParser

var fileName
var last_tick = 0
var index = 0
var notes = []

#warning-ignore: SHADOWED_VARIABLE
static func parse(fileName):
	var parser = load("res://scenes/DDR/TrackParser.gd").new(fileName)
	return parser._parse()

func _init(_fileName):
	fileName = _fileName

func _parse():
	if len(fileName) == 0:
		return
	
	var f = File.new()
	f.open(fileName, File.READ)

	while not f.eof_reached():
		index +=1
		var line = f.get_line().strip_edges()
		var data = _parse_line(line)
		if data:
			notes.push_back(data)
	
	return notes


func _parse_line(line):
	if len(line) == 0 or line[0] == '#':
		return
	
	var parts = line.split(' ')
	if len(parts) < 2:
		printerr("line (" + index + "): " + line + " is incorrect")
		return
	
	var tick = 0
	if parts[0][0] == '+':
		tick = int(parts[0].substr(1)) + last_tick
	else:
		tick = int(parts[0])
	last_tick = tick
	return {
		"tick": tick,
		"pose": parts[1].to_lower(),
	}
