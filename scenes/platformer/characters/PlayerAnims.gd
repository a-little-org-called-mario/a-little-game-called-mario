extends AnimationPlayer


func playAnim(strIn = "Idle"):
	if strIn != self.current_animation:
		self.play(strIn)
