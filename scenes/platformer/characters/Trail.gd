extends Line2D

const FileUtils = preload("res://scripts/FileUtils.gd")
export(String, DIR) var textures_directory: String
export(int) var trail_length = 5
var positions = []
var height = 0.0

onready var player: Node2D = owner

func _ready():
	var result = FileUtils._getFilePathsFromImport(textures_directory, ".png", ".jpg")
	var finalPath = result[randi() % result.size()]
	if result:
		texture = ResourceLoader.load(finalPath, "Texture")

func _process(_delta):
	global_position = Vector2(0, 0)

	while len(positions) > trail_length:
		positions.pop_front()
	positions.push_back(player.global_position + Vector2(0, height))
	points = PoolVector2Array(positions)


func reset() -> void:
	positions = []
	points = PoolVector2Array(positions)
