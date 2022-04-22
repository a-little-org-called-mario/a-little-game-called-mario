extends Enemy


export var health = 30
export var phase = 0
export var direction = -1

var attackerName = ""

var flashTime = 0

signal health_change(oldHealth, newHealth)
signal set_health(maxHealth)


func _ready():
	emit_signal("set_health", health)


func ai(delta):
	flash()
	handle_direction()
	boss_ai(delta)


# when attacked
func kill(attacker, damage = 1):
	emit_signal("health_change", health, health - damage)
	health -= damage
	attackerName = attacker
	flashTime = 2
	if health <= 0:
		no_health()


# when hp drops to 0 or below
func no_health():
	if is_dying():
		return
	_dying = true
	EventBus.emit_signal("enemy_killed")
	emit_signal("dying", attackerName)
	var res = _handle_dying(attackerName)
	if res is GDScriptFunctionState:
		yield(res, "completed")
	alive = false
	emit_signal("dead", attackerName)
	queue_free()


func _on_KillTrigger_body_entered(body):
	if not body is Player:
		kill(body.name)


# override this for boss's ai
func boss_ai(delta):
	pass


func flash():
	if flashTime > 0:
		_sprite.modulate = Color(1, 0, 0)
	else:
		_sprite.modulate = Color(1, 1, 1)
	flashTime -= 1


func handle_direction():
	_sprite.scale.x = 2 * direction

