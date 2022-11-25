extends Node2D

export var speed : float = 100

var active := false
var direction := Vector2.ZERO

onready var player : Player = get_parent()

func activate():
	active = true
	if player.input_direction:
		direction = player.input_direction
	else:
		direction = Vector2.RIGHT
	

func deactivate():
	active = false


func _physics_process(_delta):
	if active:
		if player.input_direction:
			direction = player.input_direction
		player.add_motion(direction * speed)


func _on_Player_collided(collision: KinematicCollision2D):
	if abs(collision.normal.x) >= 0.9: #Check if the collision is a wall and not the floor
		deactivate()
