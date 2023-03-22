extends KinematicBody

const GRAVITY = -40
var vel = Vector3()
const MAX_SPEED_WALK = 5
const MAX_SPEED_SPRINT = 15
const JUMP_SPEED = 18
const ACCEL = 1
const AIR_DRIFT = .1
const MOVE_SPEED = 1

var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var camera
var pivot

var MOUSE_SENSITIVITY = .1

func _ready():
	camera = $Pivot/PlayerCamera
	pivot = $Pivot

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):

	# Moving around at the speed of dependent on if sprinting
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("up"):
		input_movement_vector.y += (MOVE_SPEED if is_on_floor() else MOVE_SPEED * AIR_DRIFT)
	if Input.is_action_pressed("down"):
		input_movement_vector.y -= (MOVE_SPEED if is_on_floor() else MOVE_SPEED * AIR_DRIFT)
	if Input.is_action_pressed("left"):
		input_movement_vector.x -= (MOVE_SPEED if is_on_floor() else MOVE_SPEED * AIR_DRIFT)
	if Input.is_action_pressed("right"):
		input_movement_vector.x += (MOVE_SPEED if is_on_floor() else MOVE_SPEED * AIR_DRIFT)

	input_movement_vector = input_movement_vector.normalized()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------

	# ----------------------------------
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			vel.y = JUMP_SPEED
	# ----------------------------------

	

func process_movement(delta):
	var MAX_SPEED = MAX_SPEED_WALK if Input.is_action_pressed("sprint") else MAX_SPEED_SPRINT
	
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		pivot.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = pivot.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		pivot.rotation_degrees = camera_rot
