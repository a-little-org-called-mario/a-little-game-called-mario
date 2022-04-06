extends KinematicBody2D

const UP = Vector2.UP
const GRAVITY = 50
const MAXFALLSPEED = 500
const MAXSPEED = 300
const JUMPFORCE = 1000
const ACCEL = 50

var motion = Vector2()


func _physics_process(_delta):
	motion.y += GRAVITY

	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED

	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)

	if Input.is_action_pressed("right"):
		motion.x += ACCEL
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL
	else:
		motion.x = lerp(motion.x, 0, 0.2)

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMPFORCE
			$JumpSFX.play()

	motion = move_and_slide(motion, UP)
