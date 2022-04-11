# gassy randal kicks ASS ( n o t   r e a l l y )
# he doesn't do a lot right now, just floats and vibes. life goals tbh

extends KinematicBody2D

var rando: RandomNumberGenerator = RandomNumberGenerator.new()


#blink
func _on_BlinkTimer_timeout() -> void:
	$EyeSprite.visible = false
	$OpenTimer.start()


#open eyes back up
func _on_OpenTimer_timeout() -> void:
	$EyeSprite.visible = true
	$BlinkTimer.start()


func _process(_delta: float) -> void:
	randalRotate()
	randalVibe()


func randalRotate() -> void:
	$RandalCloud.rotation_degrees += 0.5
	$BigRandalCloud.rotation_degrees -= 0.1


func randalVibe() -> void:
	rando.randomize()
	
	position.x += rando.randf_range(-1, 1)
	position.y += rando.randf_range(-1, 1)
