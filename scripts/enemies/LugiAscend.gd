extends AnimatedSprite


const ASCEND_SPEED = 10
const ASCEND_HEIGHT = 800

var projScene = preload("res://scenes/enemies/Bullet.tscn")

var projCount = 8
var doAscend = -1
var doShoot = false


func _ready():
	visible = false


func _process(delta):
	if doAscend > 0:
		doAscend -= ASCEND_SPEED
		global_position.y -= ASCEND_SPEED
	elif doShoot:
		doShoot = false
		shoot()


func shoot():
	for i in projCount:
		var projectile = projScene.instance()
		get_parent().get_parent().add_child(projectile)
		projectile.global_position.x = global_position.x
		projectile.global_position.y = global_position.y + 148
		projectile.start_moving(Vector2(rand_range(-1, 1), 1))


func set_ascend():
	visible = true
	doAscend = ASCEND_HEIGHT
	global_position = Vector2(rand_range(100, 924), 700)
	doShoot = true
