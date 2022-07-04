extends Enemy


export var health = 5

var flashTime = 0

onready var _act_area = $ActiveArea


func _ready():
	_act_area.visible = true
	h_e_ready()


# use instead of regular ready()
func h_e_ready():
	pass


func move(delta):
	flash()
	h_e_move(delta)


# use instead of regular move()
func h_e_move(delta):
	pass


# when attacked
func kill(attacker, damage = 1):
	if alive:
		health -= damage
		flashTime = 2
		hurt()
	if health <= 0:
		no_health(attacker)


# when this enemy is attacked
func hurt():
	pass


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


func flash():
	if flashTime > 0:
		_sprite.modulate = Color(1, 0, 0)
		flashTime -= 1
	else:
		_sprite.modulate = Color(1, 1, 1)


func _on_ActiveArea_body_entered(body):
	if body is Player:
		alive = true
		activate()


# called when ActiveArea is entered
func activate():
	pass


func _on_ActiveArea_body_exited(body):
	if body is Player:
		alive = false
		deactivate()


# called when ActiveArea is left
func deactivate():
	pass

