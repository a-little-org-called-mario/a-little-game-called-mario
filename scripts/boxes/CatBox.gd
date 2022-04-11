# Spawns a cat to help Mario
extends BaseBox

export(PackedScene) var cat_scene

func on_bounce(body: KinematicBody2D):
	.on_bounce(body)
	
	if not body is Player:
		return
	
	var cat = cat_scene.instance()
	get_parent().add_child(cat)
	cat.set_player(body)
	cat.global_position = global_position - Vector2(0, 64)
