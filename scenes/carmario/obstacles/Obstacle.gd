extends Enemy

func _handle_dying(_killer):
	$AnimationPlayer.play("fly_away")
	disable_collision()
	yield($AnimationPlayer, "animation_finished")
