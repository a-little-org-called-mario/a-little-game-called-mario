class_name BallPlayer
extends KinematicBody2D

const UP = Vector2.UP
const MAXSPEED = 600
const ACCEL = 50
const SLIP_RANGE = 16

export(PackedScene) var default_projectile: PackedScene = preload("res://scenes/CoinProjectile.tscn")
export(PackedScene) var fireball_projectile: PackedScene = preload("res://scenes/powerups/Fireball.tscn")

var motion = Vector2()

onready var sprite = $Sprite
onready var tween = $Tween
onready var trail : Line2D = $Trail

onready var original_scale = sprite.scale
onready var squash_scale = Vector2(original_scale.x * 1.4, original_scale.y * 0.4)
onready var stretch_scale = Vector2(original_scale.x * 0.4, original_scale.y * 1.4)
func _ready() -> void:
	EventBus.connect("coin_collected", self, "_on_coin_collected")
	EventBus.connect("fire_flower_collected", self, "_on_flower_collected")


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Build"):
		EventBus.emit_signal("build_block", {"player":self})

	var max_speed_modifier = 1
	var acceleration_modifier = 1
	var animationSpeed = 8
	if Input.is_action_pressed("sprint"):
		max_speed_modifier = 1.5
		acceleration_modifier = 3
		animationSpeed = 60
	sprite.frames.set_animation_speed("run", animationSpeed)

	if Input.is_action_pressed("right"):
		motion.x += ACCEL * acceleration_modifier
		look_right()
		"""
		sprite.play("run")
		# pointing the character in the direction he's running
		
		"""
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL * acceleration_modifier
		look_left()
		"""
		sprite.play("run")
		
		"""
	else:
		sprite.play("idle")
		motion.x = lerp(motion.x, 0, 0.05)

	if Input.is_action_pressed("up"):
		motion.y -= ACCEL * acceleration_modifier
		"""
		sprite.play("run")
		# pointing the character in the direction he's running
		
		"""
	elif Input.is_action_pressed("down"):
		motion.y += ACCEL * acceleration_modifier
		"""
		sprite.play("run")
		
		"""
	else:
		motion.y = lerp(motion.y, 0, 0.05)


	motion.x = clamp(motion.x, -MAXSPEED * max_speed_modifier, MAXSPEED * max_speed_modifier)

	var move_and_slide_result = move_and_slide(motion, UP)
	var slide_count = get_slide_count()

	var slipped = false
	# try slipping around block corners when jumping or crossing gaps
	if slide_count:
		slipped = try_slip(get_slide_collision(slide_count - 1).get_angle())
	# apply original result if no valid slip found
	if !slipped:
		motion = move_and_slide_result


func try_slip(angle: float):
	if angle == 0:
		return false
	var axis = "x" if is_equal_approx(angle, PI) else "y"
	# is_equal_approx(abs(collision_angle - PI), PI/2)
	var original_v = position[axis]  # remember original value on axis
	# check collisions in nearby positions within SLIP_RANGE
	for r in range(1, SLIP_RANGE):
		for p in [-1, 1]:
			position[axis] = original_v + r * p
			move_and_slide(motion, UP)
			if get_slide_count() == 0:
				return true  # if no collision, return success
	# restore original value on axis if couldn't find a slip
	position[axis] = original_v
	return false


func _input(event: InputEvent):
	# Remove one coin and spawn a projectile
	# Continus shooting after 0 coins
	"""
	if event.is_action_pressed("shoot") and coins > 0:
		EventBus.emit_signal("coin_collected", { "value": -1, "type": "gold" })
		shoot(default_projectile)
	"""

# Use this for wallbanging
func land():
	squash(0.05)
	yield(tween, "tween_all_completed")
	unsquash(0.18)

"""
func shoot(projectile_scene: PackedScene):
	# Spawn the projectile and move it to its origin point
	# Origin is affected by changes to Sprite (ex: squashing)
	var projectile = projectile_scene.instance()
	get_parent().add_child(projectile)
	var shoot_dir := Vector2.LEFT if sprite.flip_h else Vector2.RIGHT
	#Changes ShootOrigin based on direction
	if shoot_dir == Vector2.LEFT:
		$Sprite/ShootOrigin.set_position(Vector2( -4, -16))
	else:
		$Sprite/ShootOrigin.set_position(Vector2( 4, -16))
	projectile.position = $Sprite/ShootOrigin.global_position
	# Projectile handles movement
	projectile.start_moving(shoot_dir)
	emit_signal("shooting")
"""

func look_right():
	sprite.flip_h = false


func look_left():
	sprite.flip_h = true


func squash(time = 0.1, _returnDelay = 0, squash_modifier = 1.0):
	tween.remove_all()
	tween.interpolate_property(
		sprite,
		"scale",
		original_scale,
		lerp(original_scale, squash_scale, squash_modifier),
		time,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	tween.interpolate_property(
		trail, "height", trail.height, 20 * squash_modifier, time, Tween.TRANS_BACK, Tween.EASE_OUT
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
		trail, "height", trail.height, 0, time, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.start()

func reset() -> void:
	look_right()


func bounce(strength = 1100):
	squash(0.075)
	yield(tween, "tween_all_completed")
	stretch(0.15)
	motion.y = -strength

func _on_coin_collected(data):
	var value := 1
	if data.has("value"):
		value = data["value"]
