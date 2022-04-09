extends Line2D

export(int) var trail_length = 5;
var positions = []

onready var parent = get_parent()

func _process(delta):
	self.global_position = Vector2(0.0, 0.0)
	
	while len(positions) > trail_length:
		positions.pop_front()
	positions.push_back(parent.global_position)
	points = PoolVector2Array(positions)
