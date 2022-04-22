extends Enemy

export (float, 0.00, 1.0, 0.05) var scare_chance := 0.0

func _handle_dying(_killer):
	$AnimationPlayer.play("fly_away")
	disable_collision()
	yield($AnimationPlayer, "animation_finished")

func scare():
	if rand_range(0.01, 0.99) > scare_chance: return
	$AnimationPlayer.play("run_away")
	disable_collision()
	yield($AnimationPlayer, "animation_finished")
	queue_free()
