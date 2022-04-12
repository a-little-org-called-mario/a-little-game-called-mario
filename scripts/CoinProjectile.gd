extends PlayerProjectile
class_name CoinProjectile


func _handle_start(_dir: Vector2) -> void:
	$Shoot.play()


func _handle_destruction() -> void:
	$Hit.play()
	$AnimationPlayer.play("disappear")
	yield($AnimationPlayer, "animation_finished")
