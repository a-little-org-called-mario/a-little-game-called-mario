extends Sprite

var speed = 200
var life = 1.5

func _process(delta):
	position.y -= speed * delta
	life -= delta
	if life < 0:
		queue_free()
