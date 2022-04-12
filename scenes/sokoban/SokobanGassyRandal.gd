# gassy randal kicks ASS
# he doesn't do a lot right now, just floats and vibes. life goals tbh

extends KinematicBody2D

var rando = RandomNumberGenerator.new()


#blink
func _on_BlinkTimer_timeout() -> void:
	$EyeSprite.visible = false
	$OpenTimer.start()
	pass


#open eyes back up
func _on_OpenTimer_timeout():
	$EyeSprite.visible = true
	$BlinkTimer.start()
	pass
