extends AnimatedSprite


export var partName = "default"

signal animate_finished(paNa, anId)


func emit_finished(aniId = 0):
	emit_signal("animate_finished", partName, aniId)

