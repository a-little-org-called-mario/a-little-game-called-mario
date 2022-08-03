extends AnimationPlayer


func playAnim(strIn = "Idle"):
	if not self.has_animation(strIn):
		return
	if strIn != self.current_animation:
		self.play(strIn)
