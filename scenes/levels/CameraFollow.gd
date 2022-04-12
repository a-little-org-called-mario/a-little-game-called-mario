extends Position2D
onready var camera_reference: Camera2D  = $"../../Camera"
onready var player_reference: Player  = $"../Player"

func _process(_delta):

	if(not player_reference):
		player_reference = $"../Player"
	if(camera_reference and player_reference):
		camera_reference.position.x = player_reference.position.x
	pass
