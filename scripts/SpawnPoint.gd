extends Position2D

var playerScene = load("res://scenes/Player.tscn")

func _ready():
	var player = null
	for c in get_node("..").get_children():
		if c is Player:
			player = c
			break
	
	if not player:
		player = playerScene.instance()
		get_node("..").call_deferred("add_child", player)
	
	player.position = self.position
	player.visible = true
