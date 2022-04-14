extends KinematicBody2D

var speed := 10000.0
var can_move := true

func _process(delta: float) -> void:
	var movement := Input.get_vector("left", "right", "up", "down")
	if not can_move:
		movement = Vector2.ZERO
	move_and_slide(movement * delta * speed)
	$AnimatedSprite.animation = "run" if movement else "idle"
	if movement:
		$AnimatedSprite.flip_h = movement.x < 0
