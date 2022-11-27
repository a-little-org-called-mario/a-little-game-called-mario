extends Node2D

export var speed : float = 200

var active := false
var direction := Vector2.ZERO

onready var player : Player = get_parent()
onready var sprite := $PeelSprite

func activate():
	active = true
	sprite.visible = true
	
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	

func deactivate():
	active = false
	sprite.visible = false


func _physics_process(_delta):
	if active:
		if player.input_direction:
			direction = player.input_direction
		scale.x = direction.x
		player.add_motion(direction * speed)


func _on_Player_collided(collision: KinematicCollision2D):
	if abs(collision.normal.x) >= 0.9: #Check if the collision is a wall rather than the floor
		deactivate()
