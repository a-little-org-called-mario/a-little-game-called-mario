extends KinematicBody2D

signal jumping

const UP = Vector2.UP
const GRAVITY = 100
const MAXFALLSPEED = 1000
const MAXSPEED = 300
const JUMPFORCE = 1200 # Adjusted to make 3 tile high jumps
const ACCEL = 50
const COYOTE_TIME = 0.1

var coyote_timer = COYOTE_TIME # used to give a bit of extra-time to jump after leaving the ground
var motion = Vector2()
var gravity_multiplier = 1 # used for jump height variability

onready var sprite = $Sprite

onready var tween = $Tween

onready var original_scale = sprite.scale;
onready var squash_scale = Vector2(original_scale.x*1.4, original_scale.y*0.4)
onready var stretch_scale = Vector2(original_scale.x * 0.4, original_scale.y * 1.4)

func _physics_process(delta : float) -> void:
	motion.y += GRAVITY * gravity_multiplier

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
		squash();
		yield(tween, "tween_all_completed")
		stretch();
		coyote_timer = 0
		motion.y = -JUMPFORCE
		$JumpSFX.play()
		emit_signal("jumping")

	if is_on_floor():
		coyote_timer = COYOTE_TIME
		gravity_multiplier = 1
	else:
		coyote_timer -= delta
		# while we're holding the jump button we should jump higher
		if Input.is_action_pressed("jump"):
			gravity_multiplier = 0.5
		else:
			gravity_multiplier = 1 
		sprite.play("jump")

	motion = move_and_slide(motion, UP)
	
func squash(time=0.1, returnDelay=0):
	tween.interpolate_property(sprite, "scale", original_scale, squash_scale, time, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start();

func stretch(time=0.2, returnDelay=0):
		tween.interpolate_property(sprite, "scale", original_scale, stretch_scale, time, Tween.TRANS_BACK, Tween.EASE_OUT)
		tween.interpolate_property(sprite, "scale", stretch_scale, original_scale, time, Tween.TRANS_BACK, Tween.EASE_OUT, time/2)
		tween.start()

func set_camera_follow(follow: bool):
	$Camera.current = follow