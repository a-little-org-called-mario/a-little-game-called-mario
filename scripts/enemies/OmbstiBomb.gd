extends KinematicBody2D


const GRAV = 20

export var bombType = "normal"
export(PackedScene) var exploScene

var velocity = Vector2(0, 0)

var direction = 1

onready var _sprite = $Sprite


func _physics_process(delta):
	scale.y = direction
	_sprite.rotation_degrees += (velocity.x / 20)
	
	velocity.y += GRAV
	move_and_slide(velocity)
	
	if is_on_wall():
		var explosion = exploScene.instance()
		explosion.global_position = global_position
		get_parent().add_child(explosion)
		queue_free()
	
