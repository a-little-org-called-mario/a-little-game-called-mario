class_name Player
extends KinematicBody2D

# This signal is emited from Shooter.gd
#warning-ignore: UNUSED_SIGNAL
signal shooting
signal crouched
signal uncrouched
signal collided(collision)

const MAXSPEED = 350
const CROUCH_MAXSPEED = MAXSPEED / 3
const MAXACCEL = 50
const MINACCEL = 0.25 * MAXACCEL
const JERK = 0.25
const SKIDTHRESHOLD = 700
const STOPTHRESHOLD = 5  # Speed at which we should stop motion if idle.
const COYOTE_TIME = 0.1
const JUMP_BUFFER_TIME = 0.05
const SLIP_RANGE = 16
const SUPER_JUMP_MAX_TIME = 0.5

var gravity = preload("res://scripts/resources/Gravity.tres")
var stats = preload("res://scripts/resources/PlayerStats.tres")

var jump_force := 1120
var push_factor := 0.3 #How strongly the player pushes rigid bodies. Scaled by speed.

var coyote_timer = COYOTE_TIME  # used to give a bit of extra-time to jump after leaving the ground
var jump_buffer_timer = 0  # gives a bit of buffer to hit the jump button before landing
var x_motion = AxisMotion.new(AxisMotion.X, MAXSPEED, MAXACCEL, JERK)
var y_motion = AxisMotion.new(gravity.direction, jump_force, gravity.strength, 0.0)
var gravity_multiplier = 1  # used for jump height variability
var double_jump = true
var crouching = false
var grounded = false
var skidding : bool = false
var skidding_force: float
var anticipating_jump = false  # the small window of time before the player jumps
var super_jumping = false
var super_jump_timer = 0.0
var powerupspeed = 1
var powerupaccel = 1
var input_direction := Vector2.ZERO #The direction the player is pressing this frame
var added_motion := Vector2.ZERO #Extra motion that needs to be added this frame, not multiplied by delta


onready var pivot: Node2D = $Pivot
onready var sprite := $Pivot/Sprite
onready var anim: AnimationPlayer = $Pivot/Sprite/Anims
onready var effect_anim: AnimationPlayer = $Pivot/Sprite/EffectAnims
onready var tween: Tween = $Tween
onready var collision: CollisionShape2D = $Collision
onready var hitbox: Area2D = $Hitbox
onready var hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D

onready var original_collision_extents: Vector2 = collision.shape.extents
onready var original_hitbox_extents: Vector2 = hitbox_collision.shape.extents


onready var original_scale = sprite.scale
onready var squash_scale = Vector2(original_scale.x * 1.4, original_scale.y * 0.4)
onready var stretch_scale = Vector2(original_scale.x * 0.4, original_scale.y * 1.4)


func _ready() -> void:
	_end_flash_sprite()
	uncrouch()


func _enter_tree():
	EventBus.connect("heart_changed", self, "_on_heart_change")
	EventBus.connect("enemy_hit_coin", self, "_on_enemy_hit_coin")
	EventBus.connect("enemy_hit_fireball", self, "_on_enemy_hit_fireball")


func _exit_tree():
	# make sure the Marios in other levels (or hub) don't receive events
	EventBus.disconnect("heart_changed", self, "_on_heart_change")
	EventBus.disconnect("enemy_hit_coin", self, "_on_enemy_hit_coin")
	EventBus.disconnect("enemy_hit_fireball", self, "_on_enemy_hit_fireball")


func _physics_process(delta: float) -> void:
	#Reset the input direction, will be changed if the player is moving
	input_direction = Vector2.ZERO
	# set these each loop in case of changes in gravity or acceleration modifiers
	x_motion.max_speed = MAXSPEED if not crouching else CROUCH_MAXSPEED
	x_motion.max_accel = MAXACCEL
	y_motion.set_axis(gravity.direction)
	y_motion.max_accel = gravity.strength
	
	# skidding threshold changes on how fast you're going.
	# tweaked until it felt good, value over 350 doesn't skid while walking. 
	skidding_force = SKIDTHRESHOLD

	x_motion.max_speed *= powerupspeed
	x_motion.max_accel *= powerupaccel
	
	var jerk_modifier = 1
	var animationSpeed = 1
	if Input.is_action_pressed("sprint"):
		stats.speed += 1
		x_motion.max_speed *= 1.5
		x_motion.max_accel *= 3


		# skids until a little before you're moving in the opposite direction to give a run up.
		skidding_force = (SKIDTHRESHOLD * powerupspeed) - (x_motion.max_speed * 1.2)
		jerk_modifier = 3
		animationSpeed = 6
	anim.playback_speed = animationSpeed
	if Input.is_action_pressed("right"):
		input_direction = Vector2.RIGHT
		
		jerk_right(JERK * jerk_modifier)
		
		skidding = x_motion.get_speed() < -skidding_force && _is_on_floor()
		anim.playAnim("Run")
			
		# pointing the character in the direction he's running
		look_right()
		
		
	elif Input.is_action_pressed("left"):
		input_direction = Vector2.LEFT
		
		jerk_left(JERK * jerk_modifier)
		skidding = x_motion.get_speed() > skidding_force && _is_on_floor()
		anim.playAnim("Run")
			
		look_left()
		
		
	else:
		anim.playAnim("Idle")
		if x_motion.get_speed() > STOPTHRESHOLD:
			jerk_left(JERK)
		elif x_motion.get_speed() < -STOPTHRESHOLD:
			jerk_right(JERK)
		else:
			x_motion.set_speed(0)
			x_motion.set_jerk(0)
			x_motion.set_accel(0)
		skidding = false
		
	if skidding:
		anim.playAnim("Skid")
	
	$SkidSFX.volume_db = clamp(abs(x_motion.get_speed()) * 0.02, 0, 10)
	$SkidSFX.playing = skidding
		
	jump_buffer_timer -= delta
	if Input.is_action_just_pressed("jump") and not super_jumping:
		# If experienced enough, do a super crouch jump
		if crouching and stats.acrobatics >= 10:
			super_jumping = true
			super_jump()
		elif coyote_timer > 0:
			jump()
		elif double_jump:
			stats.acrobatics += 1
			jump()
			double_jump = false
		else:
			jump_buffer_timer = JUMP_BUFFER_TIME

	# A super jump is a set height
	if super_jumping:
		if super_jump_timer < SUPER_JUMP_MAX_TIME:
			super_jump_timer += delta
			gravity_multiplier = 0.1
		else:
			super_jumping = false

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
		if crouching:
			uncrouch()
		coyote_timer -= delta
		# while we're holding the jump button we should jump higher
		if not super_jumping:
			if Input.is_action_pressed("jump"):
				gravity_multiplier = 0.5
			else:
				gravity_multiplier = 1
		anim.playAnim("Jump")

	if crouching and not Input.is_action_pressed("down"):
		uncrouch()

	y_motion.set_accel(gravity.strength * gravity_multiplier)
	pivot.scale.y = gravity.direction.y

	var move_and_slide_result = move_and_slide(
		y_motion.update_motion() + x_motion.update_motion() + added_motion, Vector2.UP,
		false, 4, 0.785398, false #infinite_inertia is disabled to prevent rigid bodies getting stuck in walls and similar problems
	)
	var slide_count = get_slide_count()
	
	for i in slide_count:
		var col = get_slide_collision(i)
		emit_signal("collided", col)
		
		var collider : Node2D = col.collider
		if collider is RigidBody2D: #Push any rigid bodies this collides with
			collider.apply_impulse(col.position - collider.global_position, -col.normal * push_factor * get_velocity().length())
			
	added_motion = Vector2.ZERO

	var slipped = false
	# try slipping around block corners when jumping or crossing gaps
	if slide_count:
		slipped = try_slip(get_slide_collision(slide_count - 1).get_angle())
	# apply original result if no valid slip found
	if !slipped:
		x_motion.set_motion(move_and_slide_result)
		y_motion.set_motion(move_and_slide_result)


func _is_on_floor() -> bool:
	return (
		(gravity.direction.y == Vector2.DOWN.y and is_on_floor())
		or (gravity.direction.y == Vector2.UP.y and is_on_ceiling())
	)


func try_slip(angle: float):
	if angle == 0:
		return false
	var axis = "x" if is_equal_approx(angle, PI) else "y"
	var original_v = position[axis]  # remember original value on axis
	# check collisions in nearby positions within SLIP_RANGE
	for r in range(1, SLIP_RANGE):
		for p in [-1, 1]:
			position[axis] = original_v + r * p
			move_and_slide(x_motion.get_motion() + y_motion.get_motion(), Vector2.UP)
			if get_slide_count() == 0:
				return true  # if no collision, return success
	# restore original value on axis if couldn't find a slip
	position[axis] = original_v
	return false


func crouch():
	crouching = true
	set_hitbox_crouching(collision, original_collision_extents)
	set_hitbox_crouching(hitbox_collision, original_hitbox_extents)
	squash()
	emit_signal("crouched")


func uncrouch():
	crouching = false
	set_hitbox_uncrouch(collision, original_collision_extents)
	set_hitbox_uncrouch(hitbox_collision, original_hitbox_extents)
	unsquash()
	emit_signal("uncrouched")


func set_hitbox_crouching(col, original_extents):
	col.shape.extents.y = original_extents.y * 0.4
	col.position.y = (original_extents.y - col.shape.extents.y) * gravity.direction.y


func set_hitbox_uncrouch(col, original_extents):
	col.shape.extents.y = original_extents.y
	col.position.y = 0


func jump():
	stats.jump_xp += 1
	tween.stop_all()
	anticipating_jump = true
	uncrouch()
	squash(0.03, 0, 0.5)
	yield(tween, "tween_all_completed")
	stretch(0.2, 0, 0.5, 1.2)
	jump_buffer_timer = 0
	coyote_timer = 0
	y_motion.set_speed(jump_force * -1)
	anticipating_jump = false
	$JumpSFX.play()
	EventBus.emit_signal("jumping")


func super_jump(): 
	super_jump_timer = 0
	stats.jump_xp += 1
	stats.acrobatics += 1
	tween.stop_all()
	uncrouch()
	stretch(0.2, 0, 1.0, 2.5)
	y_motion.set_speed(jump_force * -100)
	anticipating_jump = false
	$JumpSFX.play()
	EventBus.emit_signal("jumping")


func land():
	squash(0.05)
	yield(tween, "tween_all_completed")
	if grounded and not anticipating_jump:
		unsquash(0.18)


func look_right():
	pivot.scale.x = 1;


func look_left():
	pivot.scale.x = -1


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
	var trail: Line2D = get_node_or_null("Trail")
	if trail != null:
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
	var trail: Line2D = get_node_or_null("Trail")
	if trail != null:
		tween.interpolate_property(
			trail, "height", trail.height, 0, time, Tween.TRANS_BACK, Tween.EASE_OUT
		)
	tween.start()


func bounce(strength = 1100, dir = Vector2.UP):
	squash(0.075)
	yield(tween, "tween_all_completed")
	stretch(0.15)
	coyote_timer = 0
	x_motion.set_speed(strength * dir.x)
	y_motion.set_speed(strength * dir.y)


func jerk_left(jerk: float):
	if x_motion.get_accel() > -MINACCEL:
		x_motion.set_accel(-MINACCEL)
	x_motion.set_jerk(-jerk)


func jerk_right(jerk: float):
	if x_motion.get_accel() < MINACCEL:
		x_motion.set_accel(MINACCEL)
	x_motion.set_jerk(jerk)


func reset() -> void:
	look_right()
	for child in get_children():
		if child.has_method("reset"):
			child.reset()
	_end_flash_sprite()


func _on_heart_change(delta: int, total: int):
	if delta < 0:
		$HurtSFX.play()
		flash_sprite()

	if total <= 0:
		if crouching:
			uncrouch()
		EventBus.emit_signal("player_died")


func _on_enemy_hit_coin():
	stats.coin_shoot_xp += 1


func _on_enemy_hit_fireball():
	stats.intelligence += 1


func flash_sprite() -> void:
	effect_anim.play("Hurt")
	hitbox.set_deferred('monitoring', false)
	yield(effect_anim, "animation_finished")
	_end_flash_sprite()


func _end_flash_sprite() -> void:
	effect_anim.play("RESET")
	hitbox.set_deferred('monitoring', true)
	
	
func add_motion(motion: Vector2) -> void:
	added_motion += motion
	
	
func get_velocity() -> Vector2:
	return y_motion.get_motion() + x_motion.get_motion() + added_motion
