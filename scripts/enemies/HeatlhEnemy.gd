extends Enemy


export var health = 5
var active = false
var flashTime = 0


# when attacked
func kill(attacker, damage = 1):
	if active:
		emit_signal("health_change", health, health - damage)
		health -= damage
		flashTime = 2
		if health <= 0:
			no_health(attacker)


# when hp drops to 0 or below
func no_health(attacker):
	if is_dying():
		return
	_dying = true
	EventBus.emit_signal("enemy_killed")
	emit_signal("dying", attacker)
	var res = _handle_dying(attacker)
	if res is GDScriptFunctionState:
		yield(res, "completed")
	alive = false
	emit_signal("dead", attacker)
	queue_free()


# include this in move() or ai() to cause the enemy to flash red attacked
func flash():
	if flashTime > 0:
		_sprite.modulate = Color(1, 0, 0)
		flashTime -= 1
	else:
		_sprite.modulate = Color(1, 1, 1)

