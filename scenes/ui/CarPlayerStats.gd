extends Control

var ui_strings= {
	"health":"CLOUT",
	"speed":"SPEED:",
	"distance":"DISTANCE:",
	"felonies":"FELONIES:",
}

func show():
	var tr_strings= {}
	for string in ui_strings.keys():
		tr_strings[string]= tr(ui_strings[string]).to_upper()
	ui_strings= tr_strings
	$HealthTitle.text= ui_strings.health
	$Speed/Label.text= ui_strings.speed
	$Distance/Label.text= ui_strings.distance
	$Felonies/Label.text= ui_strings.felonies
	visible= true

func set_speed(value):
	$Speed/Value.text= str(value)
func set_health(ratio):
	$Health/Value.rect_scale.x= ratio
func set_distance(value):
	$Distance/Value.text= str(value)
func set_felonies(value):
	$Felonies.visible= value > 0
	$Felonies/Value.text= str(value)
