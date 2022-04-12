class_name BallSpawnPoint
extends Position2D

var player_scene = load("res://scenes/BallPlayer.tscn")


func _ready():
	spawn_mario()


func spawn_mario():
	var player = null
	for c in get_node("..").get_children():
		if c is BallPlayer:
			player = c
			break

	if not player:
		player = player_scene.instance()
		get_node("..").call_deferred("add_child", player)

	player.position = self.position
	player.visible = true
