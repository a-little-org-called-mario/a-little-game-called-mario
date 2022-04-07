extends KinematicBody2D

const UP = Vector2.UP
const GRAVITY = 100
const MAXFALLSPEED = 1000
const MAXSPEED = 300
const JUMPFORCE = 1100
const ACCEL = 50

var motion = Vector2()
var gravityMultiplier = 1; # used for jump height variability
onready var sprite = $Sprite;
func _physics_process(_delta):
	motion.y += GRAVITY * gravityMultiplier

	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED

	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)

	if Input.is_action_pressed("right"):
		motion.x += ACCEL
		sprite.play("run");
		# pointing the character in the direction he's running
		sprite.flip_h = false;
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL
		sprite.play("run");
		sprite.flip_h = true;
	else:	
		sprite.play("idle");
		motion.x = lerp(motion.x, 0, 0.2)

	if is_on_floor():
		gravityMultiplier = 1;
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMPFORCE
			$JumpSFX.play()
	else:
		# while we're holding the jump button we should jump higher
		if Input.is_action_pressed("jump"):
			gravityMultiplier = 0.5;
		else:
			gravityMultiplier = 1 
		sprite.play("jump");

	motion = move_and_slide(motion, UP)
