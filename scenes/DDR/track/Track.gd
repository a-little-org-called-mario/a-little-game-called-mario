extends Node2D

export(String, FILE) var trackFile
export(Array, NodePath) var actorPaths
var notes: Array = []
var actors: Array = []
var last_tick = 0

export(int) var spawn_delay = 30
export(int) var max_hit_delta = 300
export(float) var note_offset = 48
export(float) var note_y_offset = 300
export(PackedScene) var NoteUp
export(PackedScene) var NoteDown
export(PackedScene) var NoteLeft
export(PackedScene) var NoteRight
export(bool) var player_track = false

func _ready():
	for path in actorPaths:
		actors.push_back(get_node(path))
	notes = TrackParser.parse(trackFile)

func _process(_delta):
	if not player_track: return
	if Input.is_action_just_pressed("up"):
		$Up/AnimationPlayer.play("pressed")
	if Input.is_action_just_pressed("down"):
		$Down/AnimationPlayer.play("pressed")
	if Input.is_action_just_pressed("left"):
		$Left/AnimationPlayer.play("pressed")
	if Input.is_action_just_pressed("right"):
		$Right/AnimationPlayer.play("pressed")

func set_tick(tick):
	for i in len(notes):
		var note = notes[i]
		var note_tick = note["tick"]
		if last_tick < note_tick and note_tick <= tick:
			_set_pose(note["pose"])
			match note["pose"]:
				"up":
					$Up/AnimationPlayer.play("hit")
				"down":
					$Down/AnimationPlayer.play("hit")
				"left":
					$Left/AnimationPlayer.play("hit")
				"right":
					$Right/AnimationPlayer.play("hit")
		if last_tick + spawn_delay < note_tick and note_tick <= tick + spawn_delay:
			_spawn_note(i, note["pose"], note_tick)
		if last_tick < note_tick + max_hit_delta and note_tick + max_hit_delta <= tick:
			_note_miss(i)
	last_tick = tick
			
func _spawn_note(index, pose, note_tick):
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

func _set_pose(pose):
	for actor in actors:
		actor.pose = pose

func _on_Level_set_tick(tick):
	set_tick(tick)
	emit_signal("set_tick", tick)

func _note_miss(index):
	if not player_track || "hit" in notes[index]:
		return
	emit_signal("note_hit", -100)


func _on_player_pose_set(pose):
	if not player_track:
		return
	var res = _find_closest_pose(pose)
	var i = res[0]
	var delta = res[1]
	if i == -1 || delta > max_hit_delta:
		emit_signal("note_hit", -100)
		return
	notes[i]["hit"] = true
	var score = floor(((max_hit_delta - delta) / max_hit_delta) * 1000)
	for node in get_children():
		if "index" in node && node.index == i:
			node.queue_free()
			break
	emit_signal("note_hit", score)
	
func _find_closest_pose(pose):
	var minVal = null
	var minIndex = -1
	for i in len(notes):
		var note = notes[i]
		if note["pose"] != pose:
			continue
		var delta = abs(note["tick"] - last_tick)
		if minVal == null || minVal > delta:
			minVal = delta
			minIndex = i
	return [minIndex, minVal]

signal set_tick
signal note_hit(score)
