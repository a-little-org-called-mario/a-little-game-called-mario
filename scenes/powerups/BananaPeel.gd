extends KinematicBody2D

export var velocity := Vector2.ZERO
export var gravity : float = 100

func _physics_process(_delta):
	velocity += Vector2.DOWN * gravity
	velocity = move_and_slide(velocity)


func _on_Hitbox_body_entered(body : Player):
	if body:
		body.begin_banana_slide()
		queue_free()
