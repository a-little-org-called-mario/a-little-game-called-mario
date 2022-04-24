extends AnimatedSprite


export var groupId = 0
export var type = "basic"

var duration = 0

# should be a setting that should toggle the flashing on and off
var flashSetting = "flash"


func _ready():
	visible = false


func _process(delta):
	if duration > 0:
		duration -= 1
		play(type + "_" + flashSetting)
	else:
		visible = false


func _on_display_warning(id, time):
	if groupId == id:
		duration = time
		visible = true
