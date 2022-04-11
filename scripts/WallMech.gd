# Implements the Wall Mech enemy type.
# I'm gonna be honest, I dunno shit about Godot, so I copied this
# code from the Bubs and commented out everything that wasn't
# necessary.

extends Enemy
class_name WallMech

# General movement constants and logic borrowed from Player.
# TODO: Generalize enemy movement into a MovingEnemy class?
const UP = Vector2.UP
const RAY_CAST_WALKING_DISTANCE = 28
const MAX_SHOOTING_COOLDOWN = 2
const RAY_CAST_DISTANCE = 28
#const BOUNCE_STRENGTH = 1100

# Maximum movement speed
export(float) var max_speed = 200
export(int) var direction = -1
export(PackedScene) var bullet_scene

var _motion = Vector2.ZERO
var _moving = true
var _shooting_cooldown = 0

onready var _animation_player := $AnimationPlayer
onready var _ray_walking := $RayCastWalking
#onready var _ray_shooting := $RayCastShooting
#onready var _gun_anchor := $GunAnchor
#onready var _muzzle := $GunAnchor/Sprite/Muzzle
onready var sprite := $Sprite
onready var tween := $Tween

onready var original_scale = sprite.scale;
onready var squash_scale = Vector2(original_scale.x*1.4, original_scale.y*0.4)
onready var stretch_scale = Vector2(original_scale.x * 0.4, original_scale.y * 1.4)

func _ready():
	start_walking()
	# Uncomment the below lines to trigger death animations after 3 seconds.
	#yield(get_tree().create_timer(3.0), "timeout")
	#kill(self)


func ai(_delta: float):
	#_sprite.flip_h = direction > 0
	#_gun_anchor.scale.x = -sign(direction)
	
	if is_dying():
		return

	if _shooting_cooldown > 0:
		_shooting_cooldown -= _delta
		return

	#_ray_shooting.cast_to.x = direction * RAY_CAST_SHOOTING_DISTANCE
	#_ray_shooting.force_raycast_update()
	#if _ray_shooting.get_collider() is Player:
	#	_moving = false
	#	_animation_player.play("aim")


func move(_delta: float):
	if is_dying():
		return
	
	# What is this 'gravity' thing anywho?
	#_motion.y += GRAVITY

	#if _motion.y > MAXFALLSPEED:
	#	_motion.y = MAXFALLSPEED

	_motion.x = 0

	if _moving:
		_motion.y = clamp(_motion.y, -max_speed, max_speed)
		_motion.y = direction * max_speed
	else:
		_motion.y = 0

	_motion = move_and_slide(_motion, UP)
	
	_ray_walking.cast_to.y = direction * RAY_CAST_WALKING_DISTANCE
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
	_animation_player.play("die")
	#$SquishParticles.emitting=true
	yield(_animation_player, "animation_finished")

# called from the animation controller
func fire_bullet():
	var bullet = bullet_scene.instance()
	get_tree().root.add_child(bullet)
	# ho boy this is some good code here folks
	bullet.global_position = _animation_player.global_position #_muzzle.global_position
	bullet.scale.x = -1
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
	#player.bounce(BOUNCE_STRENGTH)
	#squash(0.075);
	#  What's with all this tweening, y'all?
	#yield(tween, "tween_all_completed")
	#stretch(0.15);


# Thankfully, this is a good an honest pixel sprite which doesn't need to
# use any stretching or squashing ;) (wink wink)

#func squash(time=0.1, returnDelay=0):
#	tween.interpolate_property(sprite, "scale", original_scale, squash_scale, time, Tween.TRANS_BACK, Tween.EASE_OUT)
#	tween.start();

#func stretch(time=0.2, returnDelay=0):
#	tween.interpolate_property(sprite, "scale", squash_scale, stretch_scale, time, Tween.TRANS_BACK, Tween.EASE_OUT)
#	tween.interpolate_property(sprite, "scale", stretch_scale, original_scale, time, Tween.TRANS_BACK, Tween.EASE_OUT, time/2)
#	tween.start()

