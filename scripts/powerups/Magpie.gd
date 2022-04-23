extends Powerup

onready var pieSprite: AnimatedSprite = $PieSprite
onready var explosionSprite: AnimatedSprite = $ExplosionSprite

func _on_body_entered(body: Node2D):
	HeartInventoryHandle.change_hearts_on(body, -3)

	if body is Player:
		var dir = body.global_position - global_position
		body.bounce(8000, dir)
	
	if explosionSprite.is_playing():
		return
	
	pieSprite.playing = false
	pieSprite.visible = false
	explosionSprite.visible = true
	explosionSprite.play("expansion")
	
	yield(explosionSprite, "animation_finished")
	# the expand & explode have different FPS, hence different animations
	explosionSprite.play("explosion")
	yield(explosionSprite, "animation_finished")
	queue_free()
	
