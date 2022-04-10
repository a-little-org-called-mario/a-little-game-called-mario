extends KinematicBody2D

const SPEED = 4

func _ready():
	pass 

func _physics_process(delta):
	var collision = move_and_collide(transform.x * SPEED)
	if collision:
	# add effect here
		queue_free()
