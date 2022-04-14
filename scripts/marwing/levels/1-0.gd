extends MarwingLevel

func _process (dt: float):
	# Maintains an infinite looping path which will be broken when we exit the dialogue
	if 1 == $Path/Marwing.unit_offset: $Path/Marwing.unit_offset = 0;
