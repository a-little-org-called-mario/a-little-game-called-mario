extends KinematicBody2D

const UP = Vector2.UP
const GRAVITY = 100
const MAXFALLSPEED = 1000
const MAXSPEED = 300
const JUMPFORCE = 1100
const ACCEL = 50
const COYOTE_TIME = 0.1

var coyote_timer = COYOTE_TIME # used to give a bit of extra-time to jump after leaving the ground
var motion = Vector2()
var gravityMultiplier = 1 # used for jump height variability
onready var sprite = $Sprite

func _physics_process(delta : float) -> void:
	motion.y += GRAVITY * gravityMultiplier

	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED

	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)

	if Input.is_action_pressed("right"):
		motion.x += ACCEL
		sprite.play("run")
		# pointing the character in the direction he's running
		sprite.flip_h = false
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL
		sprite.play("run")
		sprite.flip_h = true
	else:	
		sprite.play("idle")
		motion.x = lerp(motion.x, 0, 0.2)

	if coyote_timer > 0 and Input.is_action_just_pressed("jump"):
		coyote_timer = 0
		motion.y = -JUMPFORCE
		$JumpSFX.play()

	if is_on_floor():
		coyote_timer = COYOTE_TIME
		gravityMultiplier = 1
	else:
		coyote_timer -= delta
		# while we're holding the jump button we should jump higher
		if Input.is_action_pressed("jump"):
			gravityMultiplier = 0.5
		else:
			gravityMultiplier = 1 
		sprite.play("jump")

	motion = move_and_slide(motion, UP)
