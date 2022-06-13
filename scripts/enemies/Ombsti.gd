extends "res://scripts/enemies/HeatlhEnemy.gd"


var direction = 1
var playerLocation = Vector2(0, 0)
var delayTimer = 0

export(PackedScene) var thrownItem
export var heldItem = "bomb"
export var numberThrown = 2
export var veloMin = Vector2(150, -250)
export var veloMax = Vector2(450, -650)
export var delay = 60

onready var _ani_play = $AnimationPlayer
onready var _thr_os = $ThrownOffset


func ai(delta):
	check_player()
	set_direction()


func h_e_move(delta):
	delayTimer += 1
	if delayTimer >= delay:
		start_throw()


func set_direction():
	if playerLocation.x > position.x:
		direction = 1
	else:
		direction = -1
	scale.x = direction


func check_player():
	pass
	for i in _act_area.get_overlapping_bodies():
		if i is Player:
			playerLocation = i.position


func throw():
	if alive:
		for i in numberThrown:
			var thrown = thrownItem.instance()
			thrown.direction = direction
			thrown.velocity = Vector2(rand_range(veloMin.x, veloMax.x) * direction, rand_range(veloMin.y, veloMax.y))
			get_parent().add_child(thrown)
			thrown.global_position.x = global_position.x + (_thr_os.position.x * direction)
			thrown.global_position.y = global_position.y + _thr_os.position.y


func start_throw():
	_ani_play.play("throw")


func set_idle():
	_ani_play.play("idle")
	delayTimer = 0

