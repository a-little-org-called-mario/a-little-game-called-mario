extends Node2D

export var speed : float = 100

var active := false
var direction := Vector2.ZERO

onready var player : Player = get_parent()

func activate():
	active = true
	

func deactivate():
	active = false


func _physics_process(_delta):
	if active:
		if player.input_direction:
			direction = player.input_direction
		player.add_motion(direction * speed)


