class_name SpawnPoint
extends Position2D

export(PackedScene) var player_scene: PackedScene

var fallback_player: PackedScene = preload("res://scenes/platformer/characters/Player.tscn")


func _enter_tree():
	spawn()


func spawn():
	for node in get_parent().get_children():
		if node is Player:
			node.queue_free()

	var player: Player = (player_scene if player_scene != null else fallback_player).instance()
	if not player is Player:
		player = fallback_player.instance()
	player.set_name("Player")
	get_parent().call_deferred("add_child", player)

	player.position = self.position
	player.visible = true
