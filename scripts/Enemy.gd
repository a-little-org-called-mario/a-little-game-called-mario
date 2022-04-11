# A basic enemy class to inherit from and create individual enemies.
extends KinematicBody2D
class_name Enemy

# Emitted when the enemy is moving into a dead state.
signal dying(killer)
# Emitted when the enemy has actually shuffled off this mortal coil.
signal dead(killer)

# Determines if the enemy is alive or not. AI and movement will only
# be processed if alive is true.
export(bool) var alive: bool = true

# A midpoint between being alive and not. The enemy will die eventually,
# but will wait for things like animations to finish first.
var _dying: bool = false

onready var _collision := $CollisionShape2D
onready var _sprite := $Sprite


func _process(delta: float) -> void:
	if alive:
		ai(delta)


func _physics_process(delta: float) -> void:
	if alive:
		move(delta)


# Is the enemy in a death state?
func is_dying() -> bool:
	return _dying


func kill(killer) -> void:
	if is_dying():
		return
	_dying = true
	EventBus.emit_signal("enemy_killed")
	emit_signal("dying", killer)
	# warning-ignore:void_assignment
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
func _handle_dying(_killer) -> void:
	pass


# Helper function to disable collision. Useful if you want the enemy to
# fall through the world, for instance.
func disable_collision() -> void:
	_collision.set_deferred("disabled", true)


# Override this function to implement enemy-specific AI.
#
# The ai function is called every _process tick and is used to implement
# specific AI traits for enemies such as deciding on movement or player
# interaction. Note that decisions about movement can happen here, but
# should only be implemented in the move() function which happens during
# the physics step.
func ai(_delta: float) -> void:
	pass


# Override this function to implement enemy-specific movement.
#
# Called every _physics_process tick to move the enemy, if necessary.
func move(_delta: float) -> void:
	pass


func _on_KillTrigger_body_entered(body: KinematicBody2D) -> void:
	if body is Player:
		kill(self)
