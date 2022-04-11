extends Node2D

export(String, FILE) var noteData
export(Array, NodePath) var actorPaths
var notes: Array = []
var actors: Array = []

export(int) var spawn_delay = 30
export(float) var note_offset = 48
export(float) var note_y_offset = 300
export(PackedScene) var NoteUp
export(PackedScene) var NoteDown
export(PackedScene) var NoteLeft
export(PackedScene) var NoteRight

func _ready():
	for path in actorPaths:
		actors.push_back(get_node(path))
	_loadNotes(noteData)

func set_tick(tick):
	for note in notes:
		if note["tick"] == tick:
			set_pose(note["pose"])
		if note["tick"] == tick + spawn_delay:
			spawn_note(note["pose"])
			
func spawn_note(pose):
	var node
	match pose:
		"left":
			node = NoteLeft.instance()
			node.position.x = 0
		"down":
			node = NoteDown.instance()
			node.position.x += note_offset * 1;
		"up":
			node = NoteUp.instance()
			node.position.x += note_offset * 2;
		"right":
			node = NoteRight.instance()
			node.position.x += note_offset * 3;
		_:
			return
	node.position.y += note_y_offset
	node.speed = note_y_offset / spawn_delay
	node.life = spawn_delay
	add_child(node)

func set_pose(pose):
	for actor in actors:
		actor.pose = pose

func _loadNotes(file):
	if len(file) == 0:
		return
	var f = File.new()
	f.open(file, File.READ)
	var index = 0
	var last_tick = 0
	while not f.eof_reached():
		var line = f.get_line().strip_edges()
		index +=1
		if len(line) == 0 or line[0] == '#':
			#print(str(last_tick) + ": " + line)
			continue
		var parts = line.split(' ')
		if len(parts) < 2:
			print("line (" + index + "): " + line + " is incorrect")
			continue
		var tick = 0
		if parts[0][0] == '+':
			tick = int(parts[0].substr(1)) + last_tick
		else:
			tick = int(parts[0])
		last_tick = tick
		notes.push_back({
			"tick": tick,
			"pose": parts[1].to_lower(),
		})
	#print(notes)


func _on_Level_set_tick(tick):
	set_tick(tick)
