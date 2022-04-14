extends PlayerProjectile
class_name CoinProjectile


func _handle_start(_dir: Vector2):
	$Shoot.play()


func _handle_destruction():
	$Hit.play()
	$AnimationPlayer.play("disappear")
	yield($AnimationPlayer, "animation_finished")
	pass
