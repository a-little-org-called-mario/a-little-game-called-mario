class_name Player
extends KinematicBody2D

signal jumping

const UP = Vector2.UP
const GRAVITY = 100
const MAXFALLSPEED = 1000
const MAXSPEED = 300
const JUMPFORCE = 1100
const ACCEL = 50
const COYOTE_TIME = 0.1
const JUMP_BUFFER_TIME = 0.05
const JUMP_SLIP_RANGE = 16

var coyote_timer = COYOTE_TIME # used to give a bit of extra-time to jump after leaving the ground
var jump_buffer_timer = 0 # gives a bit of buffer to hit the jump button before landing
var motion = Vector2()
var gravity_multiplier = 1 # used for jump height variability
var double_jump = true
var crouching = false
var grounded = false
var anticipating_jump = false # the small window of time before the player jumps

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
		look_right()
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL
		sprite.play("run")
		look_left()
	else:	
		sprite.play("idle")
		motion.x = lerp(motion.x, 0, 0.2)

	jump_buffer_timer -= delta
	if Input.is_action_just_pressed("jump"):
		if coyote_timer > 0:
			jump()
		elif double_jump:
			jump()
			double_jump = false
		else:
			jump_buffer_timer = JUMP_BUFFER_TIME

	if is_on_floor():
		if not grounded:
			grounded = true
			land()
		double_jump = true
		coyote_timer = COYOTE_TIME
		gravity_multiplier = 1
		# the player pressed jump right before landing
		if jump_buffer_timer > 0:
			jump()
		elif Input.is_action_just_pressed("down"):
			crouch()
	else:
		grounded = false
		coyote_timer -= delta
		# while we're holding the jump button we should jump higher
		if Input.is_action_pressed("jump"):
			gravity_multiplier = 0.5
		else:
			gravity_multiplier = 1 
		sprite.play("jump")

	if crouching and not Input.is_action_pressed("down"):
		crouching = false
		unsquash()

	var move_and_slide_result = move_and_slide(motion, UP)
	var slide_count = get_slide_count()
	# check for an upwards-collision
	if slide_count && get_slide_collision(slide_count-1).get_angle(Vector2(0,1)) == 0:
		var slipped = try_jump_slip() # try to adjust player position to "slip" past a wall
		if !slipped:
			motion = move_and_slide_result # apply original result if no valid slip found
	else:
		motion = move_and_slide_result

func try_jump_slip():
	var original_x = position.x # remember original x position
	# check collisions in nearby x positions within JUMP_SLIP_RANGE
	for x in range(1, JUMP_SLIP_RANGE):
		for p in [-1, 1]:
			position.x = original_x + x * p
			move_and_slide(motion, UP)
			if(get_slide_count() == 0):
				return true # if no collision, return success
	# restore original x position if couldn't find a slip
	position.x = original_x
	return false

func crouch():
	crouching = true
	squash()

func jump():
	tween.stop_all()
	anticipating_jump = true
	squash(0.03, 0, 0.5)
	yield(tween, "tween_all_completed")
	stretch(0.2, 0, 0.5, 1.2);
	jump_buffer_timer = 0
	coyote_timer = 0
	motion.y = -JUMPFORCE
	anticipating_jump = false
	$JumpSFX.play()
	emit_signal("jumping")

func land():
	squash(0.05)
	yield(tween, "tween_all_completed")
	if grounded and not anticipating_jump:
		unsquash(0.18)

func look_right():
	sprite.flip_h = false

func look_left():
	sprite.flip_h = true

func squash(time=0.1, _returnDelay=0, squash_modifier=1.0):
	tween.remove_all()
	tween.interpolate_property(
		sprite, "scale",
		original_scale,
		lerp(original_scale, squash_scale, squash_modifier),
		time, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.start();

func stretch(time=0.2, _returnDelay=0, squash_modifier=1.0, stretch_modifier=1.0):
	tween.remove_all()
	tween.interpolate_property(
		sprite, "scale",
		lerp(original_scale, squash_scale, squash_modifier),
		lerp(original_scale, stretch_scale, stretch_modifier), 
		time, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.interpolate_property(
		sprite, "scale",
		lerp(original_scale, stretch_scale, stretch_modifier),
		original_scale,
		time, Tween.TRANS_BACK, Tween.EASE_OUT, time/2)
	tween.start()

func unsquash(time=0.1, _returnDelay=0, squash_modifier=1.0):
	tween.remove_all()
	tween.interpolate_property(
		sprite, "scale",
		lerp(original_scale, squash_scale, squash_modifier),
		original_scale,
		time, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.start();
