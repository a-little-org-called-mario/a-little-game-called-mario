# Implements the Bub enemy type.
# This enemy walks forward until it bumps into a wall at which point it
# reverses direction and continues. Affected by gravity and will fall
# down stairs and into pits.
#
# Bub is a friendly sort and doesn't hurt or damage the player in any
# way. He'll even give the player a lift if he cares to jump on!
#
# Bub wishes all enemies were as nice as him.
#
# Bub asset by GrafxKid at https://grafxkid.itch.io/sprite-pack-1
extends Enemy
class_name Bub

# General movement constants and logic borrowed from Player.
# TODO: Generalize enemy movement into a MovingEnemy class?
const UP = Vector2.UP
const GRAVITY = 100
const MAXFALLSPEED = 1000
const RAY_CAST_WALKING_DISTANCE = 28
const RAY_CAST_SHOOTING_DISTANCE = 600
const MAX_SHOOTING_COOLDOWN = 2
const RAY_CAST_DISTANCE = 28
const BOUNCE_STRENGTH = 1100

# Maximum movement speed
export(float) var max_speed = 150
export(int) var direction = -1
export(PackedScene) var bullet_scene
export(PackedScene) var muzzle_flash_scene

var _motion = Vector2.ZERO
var _moving = true
var _shooting_cooldown = 0

var damage = 0

onready var _animation_player := $AnimationPlayer
onready var _ray_walking := $RayCastWalking
onready var _ray_shooting := $RayCastShooting
onready var _gun_anchor := $GunAnchor
onready var _muzzle := $GunAnchor/Sprite/Muzzle
onready var sprite := $Sprite
onready var tween := $Tween
onready var pop_gun_sfx := $PopGun
onready var explode_sfx := $Explode

onready var original_scale = sprite.scale
onready var squash_scale = Vector2(original_scale.x * 1.4, original_scale.y * 0.4)
onready var stretch_scale = Vector2(original_scale.x * 0.4, original_scale.y * 1.4)


func _ready():
	start_walking()
	# Uncomment the below lines to trigger death animations after 3 seconds.
	#yield(get_tree().create_timer(3.0), "timeout")
	#kill(self)


func ai(_delta: float):
	_sprite.flip_h = direction > 0
	_gun_anchor.scale.x = -sign(direction)

	if is_dying():
		return

	if _shooting_cooldown > 0:
		_shooting_cooldown -= _delta
		return

	_ray_shooting.cast_to.x = direction * RAY_CAST_SHOOTING_DISTANCE
	_ray_shooting.force_raycast_update()
	if _ray_shooting.get_collider() is Player:
		_moving = false
		_animation_player.play("aim")


func move(_delta: float):
	if is_dying():
		return

	_motion.y += GRAVITY

	if _motion.y > MAXFALLSPEED:
		_motion.y = MAXFALLSPEED

	if _moving:
		_motion.x = clamp(_motion.x, -max_speed, max_speed)
		_motion.x = direction * max_speed
	else:
		_motion.x = 0

	_motion = move_and_slide(_motion, UP)

	_ray_walking.cast_to.x = direction * RAY_CAST_WALKING_DISTANCE
	_ray_walking.force_raycast_update()
	if _ray_walking.is_colliding():
		direction *= -1


func disable_collision():
	.disable_collision()
	_ray_walking.enabled = false
	$CollisionShape2D.queue_free()
	$KillTrigger.queue_free()


# Disables collision, plays the sprite death animation and the
# death animation from the animation player. The function then yields
# until the animations are finished.
func _handle_dying(_killer):
	disable_collision()
	if _killer is CoinProjectile:
		EventBus.emit_signal("enemy_hit_coin")
	elif _killer is Fireball:
		EventBus.emit_signal("enemy_hit_fireball")
	_animation_player.play("die")
	$SquishParticles.emitting = true
	explode_sfx.play()
	yield(_animation_player, "animation_finished")


# called from the animation controller
func fire_bullet():
	# instance bullet
	var bullet = bullet_scene.instance()
	get_parent().add_child(bullet)
	bullet.global_position = _muzzle.global_position
	bullet.scale.x = direction

	bullet.start_moving(Vector2.LEFT if direction < 0 else Vector2.RIGHT)

	# instance muzzle flash
	var flash = muzzle_flash_scene.instance()
	get_parent().add_child(flash)
	flash.scale = scale
	flash.position = _muzzle.global_position

	pop_gun_sfx.play()

	yield(_animation_player, "animation_finished")
	_shooting_cooldown = MAX_SHOOTING_COOLDOWN
	start_walking()


func start_walking():
	_moving = true
	_animation_player.play("move")


func _on_KillTrigger_body_entered(body):
	if not body is Player:
		return
	var player = body as Player
	player.stats.jump_xp += 1
	player.bounce(BOUNCE_STRENGTH)
	squash(0.075)
	yield(tween, "tween_all_completed")
	stretch(0.15)


# This isn't the best place to put these tweening functions and also copied from Player
# Couldn't this be an animation?
func squash(time = 0.1, _returnDelay = 0):
	tween.interpolate_property(
		sprite, "scale", original_scale, squash_scale, time, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.start()


func stretch(time = 0.2, _returnDelay = 0):
	tween.interpolate_property(
		sprite, "scale", squash_scale, stretch_scale, time, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.interpolate_property(
		sprite,
		"scale",
		stretch_scale,
		original_scale,
		time,
		Tween.TRANS_BACK,
		Tween.EASE_OUT,
		time / 2
	)
	tween.start()
