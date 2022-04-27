extends Enemy

func _handle_dying(_killer):
	$Oof.play()
	$AnimationPlayer.play("die")
	disable_collision()
	yield($AnimationPlayer, "animation_finished")
