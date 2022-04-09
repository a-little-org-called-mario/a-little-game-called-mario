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

var coyote_timer = COYOTE_TIME # used to give a bit of extra-time to jump after leaving the ground
var jump_buffer_timer = 0 # gives a bit of buffer to hit the jump button before landing
var motion = Vector2()
var gravity_multiplier = 1 # used for jump height variability
var double_jump = true

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
    double_jump = true
    coyote_timer = COYOTE_TIME
    gravity_multiplier = 1
    # the player pressed jump right before landing
    if jump_buffer_timer > 0:
      jump()
  else:
    coyote_timer -= delta
    # while we're holding the jump button we should jump higher
    if Input.is_action_pressed("jump"):
      gravity_multiplier = 0.5
    else:
      gravity_multiplier = 1 
    sprite.play("jump")

  motion = move_and_slide(motion, UP)

func jump():
  jump_buffer_timer = 0
  squash();
  yield(tween, "tween_all_completed")
  stretch();
  coyote_timer = 0
  motion.y = -JUMPFORCE
  $JumpSFX.play()
  emit_signal("jumping")
  
func squash(time=0.1, returnDelay=0):
  tween.interpolate_property(sprite, "scale", original_scale, squash_scale, time, Tween.TRANS_BACK, Tween.EASE_OUT)
  tween.start();

func stretch(time=0.2, returnDelay=0):
    tween.interpolate_property(sprite, "scale", original_scale, stretch_scale, time, Tween.TRANS_BACK, Tween.EASE_OUT)
    tween.interpolate_property(sprite, "scale", stretch_scale, original_scale, time, Tween.TRANS_BACK, Tween.EASE_OUT, time/2)
    tween.start()
