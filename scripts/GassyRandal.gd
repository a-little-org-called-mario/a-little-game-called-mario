# gassy randal kicks ASS
# he doesn't do a lot right now, just floats and vibes. life goals tbh
# randal is our lord

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


func _process(_delta: float):
	randalRotate()
	randalVibe()


func randalRotate():
	$RandalCloud.rotation_degrees += 0.5
	$BigRandalCloud.rotation_degrees -= 0.1
	pass


func randalVibe():
	rando.randomize()

	position.x += rando.randf_range(-1, 1)
	position.y += rando.randf_range(-1, 1)
	pass


func _ready():
	pass  # Replace with function body.
