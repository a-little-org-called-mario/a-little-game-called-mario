# Implements a moving Platform enemy type
# This moves in one direction until it collides with a wall, then turns around
# It's an Enemy, meaning the kill function can be implemented
# if you want a way to make it go away
# For some reason, when you jump into it, it falls with you.
# Don't know how to fix that.
#
# Platform asset by Hawier at https://hawier.itch.io/hawier-platformer-pack
extends Enemy
class_name Platform

# General movement constants and logic borrowed from Player.
const UP = Vector2.UP
const RAY_CAST_DISTANCE = 75

# Maximum movement speed
export(float) var max_speed = 150
export(int) var direction = -1

var _motion = Vector2.ZERO

onready var _ray := $RayCast2D


func _ready():
	pass


func move(_delta: float):
	_motion.x = clamp(_motion.x, -max_speed, max_speed)
	_motion.x = direction * max_speed
	move_and_collide(_motion * _delta)

	_ray.cast_to.x = -1 * direction * RAY_CAST_DISTANCE
	_ray.force_raycast_update()
	if _ray.is_colliding():
		direction *= -1
