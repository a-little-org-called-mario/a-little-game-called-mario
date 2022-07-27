extends "res://scripts/bosses/Boss.gd"


# the sequel
export var healthTwo = 45

var badCoinScene = preload("res://scenes/enemies/BadCoin.tscn")
var luigiEnemyScene = preload("res://scenes/enemies/Luigi.tscn")
var gassyExitScene = preload("res://scenes/bosses/GassyExit.tscn")

onready var _anim_play := $AnimationPlayer
onready var _att_play := $AttackPlayer
onready var _pivot = $Pivot

var canSpawnBad = true
var luigiSpawned = false
var pivRotation = 0

signal head_phase


func boss_ai(delta):
	if phase == 0:
		phase_0()
	elif phase == 1:
		phase_1()
	elif phase == 2:
		phase_2()
	elif phase == 3:
		phase_3()
	elif phase == 4:
		phase_4()


func phase_0():
	attackTimer += 1
	
	if health <= 55:
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
		laugh()
		start_ball()
	elif attackTimer == 150:
		dash()
	elif attackTimer == 390:
		dash()
	elif attackTimer == 540:
		laugh()
		end_ball()
		
	elif attackTimer == 570:
		ascend_projs(1)
	elif attackTimer == 660:
		ascend_projs(1)
	elif attackTimer == 750:
		ascend_projs(2)
		
	elif attackTimer == 870:
		laugh()
		badCoins()
		
	elif attackTimer == 1230:
		laugh()
		start_ball()
		phase = 4
		attackTimer = 0


func phase_4():
	attackTimer += 1
	rotate_pivot(6)
	
	if attackTimer == 60:
		dash()
	
	elif attackTimer == 120:
		ascend_projs(1)
	elif attackTimer == 210:
		ascend_projs(2)
	elif attackTimer == 300:
		ascend_projs(2)

	elif attackTimer == 390:
		dash()
	elif attackTimer == 540:
		dash()
	
	elif attackTimer == 810 and not luigiSpawned:
		luigiSpawned = true
		spawn_luigi_enemy(Vector2(512, 80))
		laugh()
	
	elif attackTimer == 900:
		attackTimer = 0



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


func laugh():
	_anim_play.play("laugh")


func start_ball():
	_att_play.play("ballStart")


func end_ball():
	_att_play.play("ballEnd")


func ascend_projs(count = 1):
	_att_play.play("ascend" + str(count))


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


func spawn_luigi_enemy(instPos = Vector2(0, 0)):
	var john = luigiEnemyScene.instance()
	connect("dying", john, "_on_boss_death")
	get_parent().get_parent().add_child(john)
	john.position = instPos
	john.fireball_count = 3


func emit_warnings(warnId, warnTime):
	emit_signal("display_warning", warnId, warnTime)


func reset_health():
	$BossBar/ProgressRed/Progress.value = 1
	maxHealth = healthTwo
	emit_signal("set_health", maxHealth)
	health = maxHealth
	canSpawnBad = true
	emit_signal("head_phase")


func rotate_pivot(pivSpeed):
	pivRotation += pivSpeed
	_pivot.rotation_degrees = pivRotation * direction


func _on_animate_finished(paNa, anId):
	if paNa == "MegaBoss":
		set_active()


func _handle_dying(_killer):
	var gassy = gassyExitScene.instance()
	get_parent().get_parent().add_child(gassy)
	connect("dead", gassy, "_on_boss_dead")
	gassy.global_position = global_position

