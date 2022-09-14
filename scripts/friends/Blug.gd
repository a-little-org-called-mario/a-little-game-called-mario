extends Area2D


const SPEED = 2
const DIST = 64

onready var _sprite := $Sprite


func _ready():
	$Collision.visible = true


func _physics_process(delta):
	var playPos = Vector2()
	for body in get_overlapping_bodies():
		if body is Player:
			playPos = body.position
	
	if playPos.x > position.x + DIST:
		position.x += SPEED
		_sprite.scale.x = 2
	elif playPos.x < position.x - DIST:
		position.x -= SPEED
		_sprite.scale.x = -2

