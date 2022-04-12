class_name Player
extends KinematicBody2D

signal shooting

const UP: Vector2 = Vector2.UP
const GRAVITY: float = 100.0
const MAXFALLSPEED: float = 1100.0
const MAXSPEED: float = 350.0
const JUMPFORCE: float = 1100.0
const ACCEL: float = 50.0
const COYOTE_TIME: float = 0.1
const JUMP_BUFFER_TIME: float = 0.05
const SLIP_RANGE: float = 16.0


export(PackedScene) var default_projectile: PackedScene = preload("res://scenes/CoinProjectile.tscn")
export(PackedScene) var fireball_projectile: PackedScene = preload("res://scenes/powerups/Fireball.tscn")

var gravity = preload("res://scripts/resources/Gravity.tres")

var coyote_timer: float = COYOTE_TIME  # used to give a bit of extra-time to jump after leaving the ground
var jump_buffer_timer: float = 0.0 # gives a bit of buffer to hit the jump button before landing
var motion: Vector2 = Vector2()
var gravity_multiplier: float = 1.0  # used for jump height variability
var double_jump: bool = true
var crouching: bool = false
var grounded: bool = false
var anticipating_jump: bool = false  # the small window of time before the player jumps
var coins: int = 0  #grabbed directly from the coin_collected signal;
var hearts: int = 3
var hasFlower: bool = false
var isBus: bool = false

onready var sprite: AnimatedSprite = $Sprite
onready var tween: Tween = $Tween
onready var trail: Line2D = $Trail
onready var run_particles: CPUParticles2D = $RunParticles

const bus_sprite: Texture = preload("res://sprites/bus.png")

onready var original_scale: Vector2 = sprite.scale
onready var squash_scale: Vector2 = Vector2(original_scale.x * 1.4, original_scale.y * 0.4)
onready var stretch_scale: Vector2 = Vector2(original_scale.x * 0.4, original_scale.y * 1.4)


func _ready() -> void:
	EventBus.connect("coin_collected", self, "_on_coin_collected")
	EventBus.connect("heart_changed", self, "_on_heart_change")
	hearts = get_node("../../UI/UI/HeartCount").count
	EventBus.connect("fire_flower_collected", self, "_on_flower_collected")
	EventBus.connect("bus_collected", self, "_on_bus_collected")


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Build"):
		EventBus.emit_signal("build_block", {"player": self})

	var max_speed_modifier: float = 1.0
	var acceleration_modifier: float = 1.0
	var animationSpeed: float = 8.0
	if Input.is_action_pressed("sprint"):
		max_speed_modifier = 1.5
		acceleration_modifier = 3
		animationSpeed = 60
	sprite.frames.set_animation_speed("run", animationSpeed)
	if Input.is_action_pressed("right"):
		motion.x += ACCEL * acceleration_modifier
		sprite.play("run")
		# pointing the character in the direction he's running
		run_particles.emitting = true
		look_right()
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL * acceleration_modifier
		sprite.play("run")
		run_particles.emitting = true
		look_left()
	else:
		sprite.play("idle")
		run_particles.emitting = false
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

	if _is_on_floor():
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
		run_particles.emitting = false

	if crouching and not Input.is_action_pressed("down"):
		crouching = false
		unsquash()

	motion.y += gravity.direction.y * gravity.strength * gravity_multiplier
	sprite.flip_v = gravity.direction.y < 0

	if abs(motion.y) > MAXFALLSPEED:
		motion.y = sign(motion.y) * MAXFALLSPEED

	motion.x = clamp(motion.x, -MAXSPEED * max_speed_modifier, MAXSPEED * max_speed_modifier)

	var move_and_slide_result = move_and_slide(motion, Vector2.UP)
	var slide_count = get_slide_count()

	var slipped = false
	# try slipping around block corners when jumping or crossing gaps
	if slide_count:
		slipped = try_slip(get_slide_collision(slide_count - 1).get_angle())
	# apply original result if no valid slip found
	if !slipped:
		motion = move_and_slide_result


func try_slip(angle: float) -> bool:
	if angle == 0:
		return false
	var axis = "x" if is_equal_approx(angle, PI) else "y"
	# is_equal_approx(abs(collision_angle - PI), PI/2)
	var original_v = position[axis]  # remember original value on axis
	# check collisions in nearby positions within SLIP_RANGE
	for r in range(1, SLIP_RANGE):
		for p in [-1, 1]:
			position[axis] = original_v + r * p
			move_and_slide(motion, Vector2.UP)
			if get_slide_count() == 0:
				return true  # if no collision, return success
	# restore original value on axis if couldn't find a slip
	position[axis] = original_v
	return false


func _input(event: InputEvent) -> void:
	# Remove one coin and spawn a projectile
	# Continus shooting after 0 coins
	if event.is_action_pressed("shoot") and coins > 0:
		EventBus.emit_signal("coin_collected", {"value": -1, "type": "gold"})
		shoot(default_projectile)
	#Shoots fireball
	if event.is_action_pressed("fire") and hasFlower:
		shoot(fireball_projectile)


func crouch() -> void:
	crouching = true
	squash()


func jump() -> void:
	tween.stop_all()
	anticipating_jump = true
	squash(0.03, 0, 0.5)
	yield(tween, "tween_all_completed")
	stretch(0.2, 0, 0.5, 1.2)
	jump_buffer_timer = 0
	coyote_timer = 0
	motion.y = JUMPFORCE * (gravity.direction.y * -1)
	anticipating_jump = false
	$JumpSFX.play()
	EventBus.emit_signal("jumping")


func land() -> void:
	squash(0.05)
	yield(tween, "tween_all_completed")
	if grounded and not anticipating_jump:
		unsquash(0.18)


func shoot(projectile_scene: PackedScene) -> void:
	# Spawn the projectile and move it to its origin point
	# Origin is affected by changes to Sprite (ex: squashing)
	var projectile = projectile_scene.instance()
	get_parent().add_child(projectile)
	var shoot_dir := Vector2.LEFT if sprite.flip_h else Vector2.RIGHT
	#Changes ShootOrigin based on direction
	if shoot_dir == Vector2.LEFT:
		$Sprite/ShootOrigin.set_position(Vector2(-4, -16))
	else:
		$Sprite/ShootOrigin.set_position(Vector2(4, -16))
	projectile.position = $Sprite/ShootOrigin.global_position
	# Projectile handles movement
	projectile.start_moving(shoot_dir)
	emit_signal("shooting")


func look_right() -> void:
	sprite.flip_h = false
	if isBus:
		$BusSprite.flip_h = true



func look_left() -> void:
	sprite.flip_h = true
	if isBus:
		$BusSprite.flip_h = false


func squash(
		time: float = 0.1,
		_returnDelay: float = 0.0,
		squash_modifier: float = 1.0) -> void:
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


func stretch(time: float = 0.2,
		_returnDelay: float = 0.0,
		squash_modifier: float = 1.0,
		stretch_modifier: float = 1.0) -> void:
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


func unsquash(time: float = 0.1,
		_returnDelay: float = 0.0,
		squash_modifier: float = 1.0) -> void:
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
	run_particles.emitting = false
	run_particles.restart()
	trail.reset()


func bounce(strength: float = 1100.0) -> void:
	squash(0.075)
	yield(tween, "tween_all_completed")
	stretch(0.15)
	coyote_timer = 0
	motion.y = -strength


func _is_on_floor() -> bool:
	return (
		(gravity.direction.y == Vector2.DOWN.y and is_on_floor())
		or (gravity.direction.y == Vector2.UP.y and is_on_ceiling())
	)

func _on_coin_collected(data: Dictionary) -> void:
	var value := 1
	if data.has("value"):
		value = data["value"]
	coins += value


func _on_heart_change(data: Dictionary) -> void:
	var value := 1
	if data.has("value"):
		value = data["value"]
	hearts += value
	if hearts <= 0:
		get_tree().reload_current_scene()


func _on_flower_collected(data: Dictionary) -> void:
	if data.has("collected"):
		hasFlower = data["collected"]


func _on_bus_collected(data: Dictionary) -> void:
	if data.has("collected"):
		isBus = data["collected"]
		$BusSprite.visible = true
		$BusCollision.visible = true
		$BusCollision.disabled = false				
		sprite.visible = false
		$CollisionShape2D.disabled = true		
		$CollisionShape2D.visible = false
		trail.height = 15
