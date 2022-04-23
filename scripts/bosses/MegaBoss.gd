extends "res://scripts/bosses/Boss.gd"


onready var _anim_play := $AnimationPlayer


func boss_ai(delta):
	if phase == 0:
		phase_1()


func phase_1():
	attackTimer += 1
	
	if attackTimer == 100:
		jump()
		
	elif attackTimer == 200:
		jump()
		
	elif attackTimer == 300:
		laser()
		
	elif attackTimer == 350:
		attackTimer = 0


func jump():
	if direction == -1:
		_anim_play.play("jumpLeft")
	else:
		_anim_play.play("jumpRight")


func idle():
	_anim_play.play("idle")


func laser():
	_anim_play.play("laser")
	emit_signal("display_warning", 0, 30)


func set_collide_layers():
	collision_layer = (32)
	collision_mask = (256)


func ready_animation():
	$AnimationPlayer.play("idle")
	direction = -1

