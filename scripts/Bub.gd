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
const RAY_CAST_DISTANCE = 28

# Maximum movement speed
export(float) var max_speed = 150
export(int) var direction = -1

var _motion = Vector2.ZERO

onready var _animation_player := $AnimationPlayer
onready var _ray := $RayCast2D


func _ready():
	_sprite.play("move")
	# Uncomment the below lines to trigger death animations after 3 seconds.
	#yield(get_tree().create_timer(3.0), "timeout")
	#kill(self)


func ai(_delta: float):
	_sprite.flip_h = direction > 0


func move(_delta: float):
	if is_dying():
		return
	
	_motion.y += GRAVITY

	if _motion.y > MAXFALLSPEED:
		_motion.y = MAXFALLSPEED

	_motion.x = clamp(_motion.x, -max_speed, max_speed)
	_motion.x = direction * max_speed
	_motion = move_and_slide(_motion, UP)
	
	_ray.cast_to.x = direction * RAY_CAST_DISTANCE
	_ray.force_raycast_update()
	if _ray.is_colliding():
		direction *= -1


func disable_collision():
	.disable_collision()
	_ray.enabled = false
	$CollisionShape2D.queue_free()
	$KillTrigger.queue_free()


# Disables collision, plays the sprite death animation and the 
# death animation from the animation player. The function then yields 
# until the animations are finished.
func _handle_dying(_killer):
	disable_collision()
	_sprite.play("die")
	_animation_player.play("die")
	$SquishParticles.emitting=true
	yield(_animation_player, "animation_finished")

