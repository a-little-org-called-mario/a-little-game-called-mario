extends KinematicBody2D


const CHARNAMES = ["Mario"]

const MAXSPEED = 350
const JUMPFORCE = 1100
const ACCELERATION = 50
const COYOTE_TIME = 0.1
const JUMP_BUFFER_TIME = 0.05
const FRICTION = 0.85

var gravity = preload("res://scripts/resources/Gravity.tres")

var coyote_timer = COYOTE_TIME  # used to give a bit of extra-time to jump after leaving the ground
var jump_buffer_timer = 0  # gives a bit of buffer to hit the jump button before landing
var gravity_multiplier = 1  # used for jump height variability
var grounded = false
var anticipating_jump = false  # the small window of time before the player jumps


var isAI = false
var state = "ground"

var velocity = Vector2()

var inpLeft = 0
var inpRight = 0
var inpLaR = 0

var charID = 0
var charName = "Mario"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not isAI:
		input()
	state()


func state():
	if state == "air":
		air()
	elif state =="ground":
		ground()


# Handles receiving inputs.
func input():
	inpLeft = Input.get_action_strength("left")
	inpRight = Input.get_action_strength("right")
	inpLaR = inpLeft*-1 + inpRight


func air():
	if is_on_floor():
		state = "ground"
	
	$Sprite/Anims.current_animation = charName + "Jump"
	
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
	
	print(stepify(velocity.x, 80))
	if stepify(velocity.x, 80) == 0:
		$Sprite/Anims.current_animation = charName + "Idle"
	else:
		$Sprite/Anims.current_animation = charName + "Run"
	
	handle_movement()


func handle_gravity():
	velocity.y += gravity.strength*0.8
