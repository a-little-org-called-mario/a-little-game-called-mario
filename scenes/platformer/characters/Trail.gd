extends Line2D

export(String, DIR) var textures_directory: String
export(int) var trail_length = 10
var positions = []
var height = 0.0

onready var parent = get_parent()
	
static func _get_random_texture_in_dir(path: String, line_texture: Texture):
	var dir := Directory.new()
	var textures := []
	print(dir.open(path))
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var filename := dir.get_next()
		while filename != "":
			if filename != "." and filename != ".." and !dir.current_is_dir() and (filename.ends_with(".jpg") or filename.ends_with(".png")):
				textures.append("%s/%s" % [path, filename])
			filename = dir.get_next()
		dir.list_dir_end()
	else:
		 return dir.open(path)
		
	if len(textures) > 0:
		randomize()
		return load(textures[randi() % textures.size()])
	else:
		return ""
func _ready():
	texture = _get_random_texture_in_dir(textures_directory, texture)

func _process(_delta):
	global_position = Vector2(0, 0)

	while len(positions) > trail_length:
		positions.pop_front()
	positions.push_back(parent.global_position + Vector2(0, height))
	points = PoolVector2Array(positions)


func reset() -> void:
	positions = []
	points = PoolVector2Array(positions)
