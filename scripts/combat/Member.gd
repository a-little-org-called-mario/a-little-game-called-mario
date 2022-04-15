extends KinematicBody2D


const CHARNAMES = ["Mario"]

const MAXSPEED = 350
const JUMPFORCE = 1100
const ACCELERATION = 50
const JUMP_BUFFER_TIME = 4
const FRICTION = 0.85

var gravity = preload("res://scripts/resources/Gravity.tres")

var grounded = false
var anticipating_jump = false  # the small window of time before the player jumps

var isAI = false
var state = "ground"
var jumpTime = 0

var velocity = Vector2()

var inpLeft = 0
var inpRight = 0
var inpLaR = 0
var inpJump = 0

var charID = 0
var charName = "Mario"

onready var tween = $Tween
onready var sprite = $Sprite

onready var original_scale = sprite.scale
onready var squash_scale = Vector2(original_scale.x * 1.4, original_scale.y * 0.4)
onready var stretch_scale = Vector2(original_scale.x * 0.4, original_scale.y * 1.4)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not isAI:
		input()
	state()


func state():
	change_state()
	
	if state == "air":
		air()
	elif state =="ground":
		ground()


func change_state():
	if state == "air":
		if is_on_floor():
			state = "ground"
			squash(0.05)
			yield(tween, "tween_all_completed")
			if is_on_floor() and not anticipating_jump:
				unsquash(0.18)

	if state == "ground":
		if not is_on_floor():
			state = "air"


# Handles receiving inputs.
func input():
	inpLeft = Input.get_action_strength("left")
	inpRight = Input.get_action_strength("right")
	inpLaR = inpLeft*-1 + inpRight
	
	inpJump = Input.is_action_just_pressed("jump")


func air():
	if is_on_floor():
		state = "ground"
	
	$Sprite/Anims.current_animation = charName + "Jump"
	$RunParticles.emitting = false
	
	jumpTime -= 1
	if inpJump:
		jumpTime = JUMP_BUFFER_TIME
	
	handle_movement()


func handle_movement():
	# Changing the velocity.
	velocity.x += ACCELERATION * inpLaR
	if velocity.x > MAXSPEED:
		velocity.x = MAXSPEED
	elif velocity.x < MAXSPEED*-1:
		velocity.x = MAXSPEED*-1
	
	# Slowing down.
	if inpLaR == 0:
		velocity.x *= FRICTION
	
	handle_gravity()
	
	velocity = move_and_slide(velocity, Vector2(0, -1))


func ground():
	if not is_on_floor():
		state = "air"
	
	if inpJump or jumpTime > 0:
		jumpTime = 0
		jump()
	
	if stepify(velocity.x, 80) == 0:
		$Sprite/Anims.current_animation = charName + "Idle"
		$RunParticles.emitting = false
	else:
		$Sprite/Anims.current_animation = charName + "Run"
		$RunParticles.emitting = true
	
	handle_movement()


func handle_gravity():
	velocity.y += gravity.strength*0.9


func jump():
	tween.stop_all()
	anticipating_jump = true
	squash(0.03, 0, 0.5)
	yield(tween, "tween_all_completed")
	stretch(0.2, 0, 0.5, 1.2)
	velocity.y = JUMPFORCE * -1
	anticipating_jump = false
	$JumpSFX.play()
	EventBus.emit_signal("jumping")


func squash(time = 0.1, _returnDelay = 0, squash_modifier = 1.0):
	tween.remove_all()
	tween.interpolate_property(
		$Sprite,
		"scale",
		original_scale,
		lerp(original_scale, squash_scale, squash_modifier),
		time,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	tween.interpolate_property(
		$Trail, "height", $Trail.height, 20 * squash_modifier, time, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.start()


func stretch(time = 0.2, _returnDelay = 0, squash_modifier = 1.0, stretch_modifier = 1.0):
	tween.remove_all()
	tween.interpolate_property(
		sprite,
		"scale",
		lerp(original_scale, squash_scale, squash_modifier),
		lerp(original_scale, stretch_scale, stretch_modifier),
		time,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	tween.interpolate_property(
		sprite,
		"scale",
		lerp(original_scale, stretch_scale, stretch_modifier),
		original_scale,
		time,
		Tween.TRANS_BACK,
		Tween.EASE_OUT,
		time / 2
	)
	tween.start()


func unsquash(time = 0.1, _returnDelay = 0, squash_modifier = 1.0):
	tween.remove_all()
	tween.interpolate_property(
		sprite,
		"scale",
		lerp(original_scale, squash_scale, squash_modifier),
		original_scale,
		time,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	tween.interpolate_property(
		$Trail, "height", $Trail.height, 0, time, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.start()

