extends "res://scripts/enemies/HeatlhEnemy.gd"


var direction = 1
var playerLocation = Vector2(0, 0)


func ai(delta):
	get_player_location()
	set_direction()


func set_direction():
	if playerLocation.x > position.x:
		direction = 1
	else:
		direction = -1
	scale.x = direction


func get_player_location():
	for i in _act_area.get_overlapping_bodies():
		if i is Player:
			playerLocation = i.position

