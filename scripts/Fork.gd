#this is a fork
#it will sometimes fall from the sky
#completely normmal
extends KinematicBody2D

var rando = RandomNumberGenerator.new()
const y_limit = 600
var y_movement = 0
var rot_rate = 0


func _process(delta: float):
	$Sprite.rotation_degrees += rot_rate

	position.y += y_movement
	#reset once it gets too far
	if position.y > y_limit:
		position.y -= y_limit * 1.1
		rot_rate = rando.randf_range(-2, 2)

	pass


func _ready():
	#launch that fork!
	rando.randomize()
	#randomize the rate that it falls and the rotation
	y_movement = rando.randf_range(2, 5)
	rot_rate = rando.randf_range(-2, 2)
	pass  # Replace with function body.
