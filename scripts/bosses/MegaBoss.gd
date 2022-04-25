extends "res://scripts/bosses/Boss.gd"


var badCoinScene = preload("res://scenes/enemies/BadCoin.tscn")

onready var _anim_play := $AnimationPlayer
onready var _att_play := $AttackPlayer
onready var _pivot = $Pivot

var canSpawnBad = true
var pivRotation = 0


func boss_ai(delta):
	if phase == 0:
		phase_0()
	elif phase == 1:
		phase_1()
	elif phase == 2:
		phase_2()
	elif phase == 3:
		phase_3()


func phase_0():
	attackTimer += 1
	
	if health <= 20:
		if _anim_play.current_animation == "idle":
			phase = 1
			attackTimer = 0
	
	if attackTimer == 120:
		jump()
		
	elif attackTimer == 180:
		badCoins()
		
	elif attackTimer == 360:
		jump()
		
	elif attackTimer == 480:
		laser()
		
	elif attackTimer == 540:
		attackTimer = 0


func phase_1():
	attackTimer += 1
	
	if health <= 10:
		if health < 5:
			health = 5
		if _anim_play.current_animation == "idle":
			canSpawnBad = false
			phase = 2
			attackTimer = 0
	
	if attackTimer == 30:
		jump()
		
	elif attackTimer == 60:
		laser()
		
	elif attackTimer == 180:
		jump()
		badCoins()
		
	elif attackTimer == 255:
		laser()
		
	elif attackTimer == 420:
		attackTimer = 0


func phase_2():
	if health < 5:
		health = 5
	if _anim_play.current_animation == "idle":
		_anim_play.play("transform")


func phase_3():
	attackTimer += 1
	rotate_pivot(4)
	
	if attackTimer == 60:
		start_ball()
	elif attackTimer == 120:
		dash()
	elif attackTimer == 360:
		dash()


func jump():
	if direction == -1:
		_anim_play.play("jumpLeft")
	else:
		_anim_play.play("jumpRight")


func dash():
	if direction == -1:
		_anim_play.play("dashLeft")
	else:
		_anim_play.play("dashRight")


func idle():
	_anim_play.play("idle")


func laser():
	_anim_play.play("laser")
	emit_signal("display_warning", 0, 30)


func badCoins():
	_att_play.play("badcoins")


func float_idle():
	_anim_play.play("float")


func start_ball():
	_att_play.play("ballStart")


func set_collide_layers():
	collision_layer = (32)
	collision_mask = (256)


func ready_animation():
	$AnimationPlayer.play("idle")
	direction = -1
	position = Vector2(0, 0)


func spawn_bad_coin(instPos = Vector2(0, 0)):
	if canSpawnBad:
		var bad = badCoinScene.instance()
		get_parent().add_child(bad)
		bad.global_position = instPos


func emit_warnings(warnId, warnTime):
	emit_signal("display_warning", warnId, warnTime)


func reset_health():
	emit_signal("health_change", health, maxHealth)
	health = maxHealth
	canSpawnBad = true


func rotate_pivot(pivSpeed):
	pivRotation += pivSpeed
	_pivot.rotation_degrees = pivRotation * direction

