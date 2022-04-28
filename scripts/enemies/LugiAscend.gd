extends AnimatedSprite


var projScene = preload("res://scenes/enemies/Bullet.tscn")

var projCount = 8


func _process(delta):
	shoot()


func shoot():
	for i in projCount:
		var projectile = projScene.instance()
		get_parent().add_child(projectile)
		projectile.global_position = position
		projectile.start_moving(Vector2(rand_range(-1, 1), 1))

