extends Sprite

var speed = 10
var life = 10

func _process(delta):
	var pos = position
	pos.y -= speed
	position = pos
	
	life -= 1
	if life < 0:
		queue_free()
