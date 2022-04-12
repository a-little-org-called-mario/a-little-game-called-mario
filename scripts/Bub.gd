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
const UP: Vector2 = Vector2.UP
const GRAVITY: float = 100.0
const MAXFALLSPEED: float = 1000.0
const RAY_CAST_WALKING_DISTANCE: float = 28.0
const RAY_CAST_SHOOTING_DISTANCE: float = 600.0
const MAX_SHOOTING_COOLDOWN: float = 2.0
const RAY_CAST_DISTANCE: float = 28.0
const BOUNCE_STRENGTH: float = 1100.0

# Maximum movement speed
export(float) var max_speed: float = 150.0
export(int) var direction: float = -1
export(PackedScene) var bullet_scene: PackedScene
export(PackedScene) var muzzle_flash_scene: PackedScene

var _motion: Vector2 = Vector2.ZERO
var _moving: bool = true
var _shooting_cooldown: float = 0.0

onready var _animation_player := $AnimationPlayer
onready var _ray_walking := $RayCastWalking
onready var _ray_shooting := $RayCastShooting
onready var _gun_anchor := $GunAnchor
onready var _muzzle := $GunAnchor/Sprite/Muzzle
onready var sprite := $Sprite
onready var tween := $Tween
onready var pop_gun_sfx := $PopGun

onready var original_scale: Vector2 = sprite.scale
onready var squash_scale: Vector2 = Vector2(original_scale.x * 1.4, original_scale.y * 0.4)
onready var stretch_scale: Vector2 = Vector2(original_scale.x * 0.4, original_scale.y * 1.4)


func _ready() -> void:
	start_walking()
	# Uncomment the below lines to trigger death animations after 3 seconds.
	#yield(get_tree().create_timer(3.0), "timeout")
	#kill(self)


func ai(_delta: float) -> void:
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


func move(_delta: float) -> void:
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


func disable_collision() -> void:
	.disable_collision()
	_ray_walking.enabled = false
	$CollisionShape2D.queue_free()
	$KillTrigger.queue_free()


# Disables collision, plays the sprite death animation and the
# death animation from the animation player. The function then yields
# until the animations are finished.
func _handle_dying(_killer: KinematicBody2D) -> void:
	disable_collision()
	_animation_player.play("die")
	$SquishParticles.emitting = true
	yield(_animation_player, "animation_finished")


# called from the animation controller
func fire_bullet() -> void:
	# instance bullet
	var bullet = bullet_scene.instance()
	get_parent().add_child(bullet)
	bullet.global_position = _muzzle.global_position
	bullet.scale.x = direction

	bullet.start_moving(Vector2.LEFT if direction < 0 else Vector2.RIGHT)

	# instance muzzle flash
	var flash = muzzle_flash_scene.instance()
	get_tree().root.add_child(flash)
	flash.global_position = _muzzle.global_position

	pop_gun_sfx.play()

	yield(_animation_player, "animation_finished")
	_shooting_cooldown = MAX_SHOOTING_COOLDOWN
	start_walking()


func start_walking() -> void:
	_moving = true
	_animation_player.play("move")


func _on_KillTrigger_body_entered(body: KinematicBody2D) -> void:
	if not body is Player:
		return
	var player = body as Player
	player.bounce(BOUNCE_STRENGTH)
	squash(0.075)
	yield(tween, "tween_all_completed")
	stretch(0.15)


# This isn't the best place to put these tweening functions and also copied from Player
# Couldn't this be an animation?
func squash(time: float = 0.1, _returnDelay: float = 0) -> void:
	tween.interpolate_property(
		sprite, "scale", original_scale, squash_scale, time, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	tween.start()


func stretch(time: float = 0.2, _returnDelay: float = 0) -> void:
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
