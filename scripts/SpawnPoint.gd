class_name SpawnPoint
extends Position2D

var player_scene: PackedScene = load("res://scenes/Player.tscn")

func _ready() -> void:
	spawn_mario()

func spawn_mario() -> void:
	var player = null
	for c in get_node("..").get_children():
		if c is Player:
			player = c
			break
	
	if not player:
		player = player_scene.instance()
		get_node("..").call_deferred("add_child", player)
	
	player.position = self.position
	player.visible = true
