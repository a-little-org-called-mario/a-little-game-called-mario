extends Area2D

func play(pitch := 1.0):
	if $AnimationPlayer.is_playing(): return
	$Sound.pitch_scale= pitch
	$AnimationPlayer.play("honk")
	for body in get_overlapping_bodies():
		if body.is_in_group("enemy") and body.has_method("scare"):
			body.scare()
