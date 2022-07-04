extends Enemy


export var active = true
export var health = 100
export var phase = 0
export var direction = -1

var coinScene = preload("res://scenes/Coin/FallingCoin.tscn")
var popcornScene = preload("res://scenes/PopcornKernel.tscn")

var attackerName = ""
var maxHealth = 100
var flashTime = 0
var attackTimer = 0
var canChangePhase = false
var startedBar = false
onready var _boss_bar = $BossBar

# probably not neeeded
var posOrigin = Vector2(0, 0)
var posOffset = Vector2(0, 0)

signal health_change(oldHealth, newHealth)
signal set_health(maxHealth)
signal display_warning(id, time)


func _ready():
	if active:
		emit_signal("set_health", health)
	set_collide_layers()
	ready_animation()
	maxHealth = health


func move(delta):
	# position = posOrigin + posOffset
	flash()
	handle_direction()
	if active:
		boss_ai(delta)
	else:
		visible = false
		_boss_bar.change_visible(false)
		


# when attacked
func kill(attacker, damage = 1):
	if active:
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
	scale.x = direction
	

# change collision layers/masks here
func set_collide_layers():
	pass
	

# set animation stuff
func ready_animation():
	pass


# instance a coin
func spawn_coin(offset = Vector2(0, 0), selfRelative = true, value = 1):
	var coin = coinScene.instance()
	get_parent().add_child(coin)
	coin.value = value
	if selfRelative:
		coin.global_position = global_position + offset
	else:
		coin.global_position = offset

# instance the popcorn (not yummy)
func spawn_popcorn(offset = Vector2(0, 0), selfRelative = false, number = 1):
	for i in range(number):
		var pop = popcornScene.instance()
		get_parent().add_child(pop)
		if selfRelative:
			pop.global_position = global_position + offset
		else:
			pop.global_position = offset



func small_shake():
	EventBus.emit_signal("small_screen_shake")


func large_shake():
	EventBus.emit_signal("large_screen_shake")


func set_active():
	active = true
	visible = true
	_boss_bar.change_visible(true)
	if not startedBar:
		emit_signal("set_health", health)

