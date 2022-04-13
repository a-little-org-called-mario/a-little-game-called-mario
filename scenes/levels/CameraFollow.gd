extends Position2D
onready var camera_reference: Camera2D  = $"../../Camera"
onready var player_reference: Player  = $"../Player"
export var follow_horizontally: bool = true
export var follow_vertically: bool = false
export(float,0,1) var follow_speed: float = 0.1

func _process(_delta):
	
	if(not player_reference):
		print("not player")
		player_reference = $"../Player"

	if(camera_reference and player_reference):
		if(follow_horizontally):
			camera_reference.position.x = lerp(camera_reference.position.x, player_reference.position.x, follow_speed)
		if(follow_vertically):
			camera_reference.position.y = lerp(camera_reference.position.y, player_reference.position.y, follow_speed)
	
	pass
