extends Control

func _ready():
	check_os_browser()
	Settings.load_data()

func check_os_browser ():
	var agent: String = JavaScript.eval("navigator.userAgent")
	
	#disable marwing label on mac + chrome
	if "Mac" in agent and "Chrome" in agent:
		$VBoxContainer/VBoxContainer/HBoxContainer/MarwingButton.hide()