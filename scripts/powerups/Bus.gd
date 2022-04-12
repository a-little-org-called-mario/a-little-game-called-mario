#Bus asset from https://www.pngpix.com/download/bus-png-transparent-image
extends Powerup
class_name Bus

func _on_body_entered(_body):
	call_deferred("collect", "bus_collected")
