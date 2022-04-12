extends Line2D

export(int) var trail_length = 5
var positions = []
var height = 0.0

onready var parent = get_parent()


func _process(_delta):
	global_position = Vector2(0, 0)

	while len(positions) > trail_length:
		positions.pop_front()
	positions.push_back(parent.global_position + Vector2(0, height))
	points = PoolVector2Array(positions)


func reset() -> void:
	positions = []
	points = PoolVector2Array(positions)
