extends Control


export var movePositon = 0

var iconBase = "Hammer"
var moveFocused = false


func _ready():
	pass


func _process(delta):
	handle_sprite()


func handle_sprite():
	if moveFocused:
		$Sprite.animation = iconBase + "On"
	else:
		$Sprite.animation = iconBase + "Off"

