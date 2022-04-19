extends Powerup

onready var pieSprite: AnimatedSprite = $PieSprite
onready var explosionSprite: AnimatedSprite = $ExplosionSprite

func _on_body_entered(body: Node2D):
	pieSprite.playing = false
	pieSprite.visible = false
	explosionSprite.playing = true
	explosionSprite.visible = true

	HeartInventoryHandle.change_hearts_on(body, -2)

	if body is Player:
		var dir = body.global_position - global_position
		body.bounce(8000, dir)
	
	yield(explosionSprite, "animation_finished")
	queue_free()
	
