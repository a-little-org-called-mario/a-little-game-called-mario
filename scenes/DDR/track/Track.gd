extends Node2D

export(String, FILE) var trackFile
export(Array, NodePath) var actorPaths
var notes: Array = []
var actors: Array = []
var last_tick = 0

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
	notes = TrackParser.parse(trackFile)

func set_tick(tick):
	for note in notes:
		var note_tick = note["tick"]
		if last_tick < note_tick and note_tick <= tick:
			set_pose(note["pose"])
		if last_tick + spawn_delay < note_tick and note_tick <= tick + spawn_delay:
			spawn_note(note["pose"], note_tick)
	last_tick = tick
			
func spawn_note(pose, note_tick):
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
	
	node.init_pos = node.position.y + note_y_offset
	node.init_tick = note_tick - spawn_delay
	node.target_tick = note_tick
	node.target_pos = position.y
	
	connect("set_tick", node, "set_tick")
	add_child(node)

func set_pose(pose):
	for actor in actors:
		actor.pose = pose

func _on_Level_set_tick(tick):
	set_tick(tick)
	emit_signal("set_tick", tick)

signal set_tick
