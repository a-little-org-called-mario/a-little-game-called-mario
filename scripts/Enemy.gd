# A basic enemy class to inherit from and create individual enemies.
extends KinematicBody2D
class_name Enemy

# Emitted when the enemy is moving into a dead state.
signal dying(killer)
# Emitted when the enemy has actually shuffled off this mortal coil.
signal dead(killer)

# Determines if the enemy is alive or not. AI and movement will only
# be processed if alive is true.
export(bool) var alive = true

# A midpoint between being alive and not. The enemy will die eventually,
# but will wait for things like animations to finish first.
var _dying = false

onready var _collision := $CollisionShape2D
# This is used from outside
#warning-ignore:UNUSED_CLASS_VARIABLE
onready var _sprite := $Sprite


func _process(delta: float):
	if alive:
		ai(delta)


func _physics_process(delta: float):
	if alive:
		move(delta)


# Is the enemy in a death state?
func is_dying() -> bool:
	return _dying


func kill(killer):
	if is_dying():
		return
	_dying = true
	EventBus.emit_signal("enemy_killed")
	emit_signal("dying", killer)
	var res = _handle_dying(killer)
	if res is GDScriptFunctionState:
		yield(res, "completed")
	alive = false
	emit_signal("dead", killer)
	queue_free()


# Override this function to implement enemy-specific death animations,
# sounds, effects, etc.
#
# Prepares the enemy for leaving their physical form. Trigger any death
# animations or sounds here. Supports yielding until animations, etc. are
# completed. Once this function returns the enemy will be removed.
func _handle_dying(_killer):
	pass


# Helper function to disable collision. Useful if you want the enemy to
# fall through the world, for instance.
func disable_collision():
	_collision.set_deferred("disabled", true)


# Override this function to implement enemy-specific AI.
#
# The ai function is called every _process tick and is used to implement
# specific AI traits for enemies such as deciding on movement or player
# interaction. Note that decisions about movement can happen here, but
# should only be implemented in the move() function which happens during
# the physics step.
func ai(_delta: float):
	pass


# Override this function to implement enemy-specific movement.
#
# Called every _physics_process tick to move the enemy, if necessary.
func move(_delta: float):
	pass


func _on_KillTrigger_body_entered(body):
	if body is Player:
		kill(self)
