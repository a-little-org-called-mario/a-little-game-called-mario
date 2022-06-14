extends "res://scripts/enemies/HeatlhEnemy.gd"


var direction = 1
var playerLocation = Vector2(0, 0)
var delayTimer = 0

export(PackedScene) var thrownItem
export(PackedScene) var deathScene
export var heldItem = "bomb"
export var numberThrown = 2
export var veloMin = Vector2(150, -250)
export var veloMax = Vector2(450, -650)
export var delay = 70

onready var _ani_play = $AnimationPlayer
onready var _thr_os = $ThrownOffset
onready var _hit = $HitSFX
onready var _hitbox_col = $Hitbox/Collision


func _enter_tree():
	EventBus.connect("player_attacked",self,"_on_attacked")


func _exit_tree():
	EventBus.disconnect("player_attacked",self,"_on_attacked")


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
	for i in _act_area.get_overlapping_bodies():
		if i is Player:
			playerLocation = i.position


func throw():
	if alive:
		for i in numberThrown:
			var thrown = thrownItem.instance()
			thrown.throwerName = name
			thrown.direction = direction
			thrown.velocity = Vector2(rand_range(veloMin.x, veloMax.x) * direction, rand_range(veloMin.y, veloMax.y))
			get_parent().add_child(thrown)
			thrown.global_position.x = global_position.x + (_thr_os.position.x * direction)
			thrown.global_position.y = global_position.y + _thr_os.position.y


func start_throw():
	_ani_play.play("throw")


func set_idle():
	if _ani_play.current_animation != "celebrate":
		_ani_play.play("idle")
		delayTimer = 0


func _on_attacked(enemyName):
	if enemyName == name:
		_ani_play.play("celebrate")
		delayTimer = delay / 2


func hurt():
	_hit.play()


func _handle_dying(killer):
	_hitbox_col.set_deferred("disabled", true)
	var onDeath = deathScene.instance()
	get_parent().add_child(onDeath)
	onDeath.global_position.x = global_position.x
	onDeath.global_position.y = global_position.y - 24

