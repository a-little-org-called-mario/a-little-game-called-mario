extends Line2D

export(String, DIR) var textures_directory: String
export(int) var trail_length = 5
var positions = []
var height = 0.0

onready var parent = get_parent()
onready var player: Node2D = owner
	
static func _get_random_texture_in_dir(path: String):
	var dir := Directory.new()
	var textures := []
	print(dir.open(path))
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var filename := dir.get_next()
		while filename != "":
			if filename != "." and filename != ".." and !dir.current_is_dir() and (filename.ends_with(".jpg.import") or filename.ends_with(".png.import")):
				textures.append("%s/%s" % [path, filename])
			filename = dir.get_next()
		dir.list_dir_end()
	else:
		#print errorcode on fail cause idk how to view in godot's debug
		#print(dir.open(path))
		return false
		
	if len(textures) > 0:
		var texturePath = String(textures[randi() % textures.size()])
		texturePath = texturePath.rstrip(".import")
		return ResourceLoader.load(texturePath, "Texture")
	else:
		return false
func _ready():
	randomize()
	var result = _get_random_texture_in_dir(textures_directory)
	if result:
		texture = result

func _process(_delta):
	global_position = Vector2(0, 0)

	while len(positions) > trail_length:
		positions.pop_front()
	positions.push_back(player.global_position + Vector2(0, height))
	points = PoolVector2Array(positions)


func reset() -> void:
	positions = []
	points = PoolVector2Array(positions)
