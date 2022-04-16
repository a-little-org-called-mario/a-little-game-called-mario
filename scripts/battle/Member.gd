extends KinematicBody2D


const CHARNAMES = ["Plumber"]

const MAXSPEED = 350
const JUMPFORCE = 1100
const ACCELERATION = 50
const JUMP_BUFFER_TIME = 4
const FRICTION = 0.85

export var charID = 0
export var isAI = false

var gravity = preload("res://scripts/resources/Gravity.tres")

var grounded = false
var anticipating_jump = false  # the small window of time before the player jumps

var state = "ground"
var jumpTime = 0
var selectedMove = 2

var velocity = Vector2()

var inpLeft = 0
var inpRight = 0
var inpLaR = 0
var inpJump = 0
var inpBleft = 0
var inpBright = 0

var charName = "Plumber"

var rng = RandomNumberGenerator.new()

onready var tween = $Tween
onready var sprite = $Sprite

onready var original_scale = sprite.scale
onready var squash_scale = Vector2(original_scale.x * 1.4, original_scale.y * 0.4)
onready var stretch_scale = Vector2(original_scale.x * 0.4, original_scale.y * 1.4)

signal change_selected(new_move)

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not isAI:
		input()
	else:
		ai_input()
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


func ai_input():
	inpJump = 0
	if rng.randi_range(1, 15) == 1:
		inpLaR = rng.randi_range(-1, 1)
	if rng.randi_range(1, 200) == 1:
		inpJump = 1


# Handles receiving inputs.
func input():
	inpLeft = Input.get_action_strength("left")
	inpRight = Input.get_action_strength("right")
	inpLaR = inpLeft*-1 + inpRight
	
	inpJump = Input.is_action_just_pressed("jump")
	
	inpBleft = Input.is_action_just_pressed("battle_moves_left")
	inpBright = Input.is_action_just_pressed("battle_moves_right")


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
	
	if (inpBleft or inpBright) and not isAI:
		handle_move_select()


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


func handle_move_select():
	if inpBleft:
		selectedMove -= 1
	if inpBright:
		selectedMove += 1
	
	if selectedMove < 0:
		selectedMove = 4
	elif selectedMove > 4:
		selectedMove = 0
	
	emit_signal("change_selected", selectedMove)

