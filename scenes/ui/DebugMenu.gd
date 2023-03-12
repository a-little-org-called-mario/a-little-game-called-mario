extends Control

const STARTUP_SECTION = "startup"

onready var main := get_node("/root/Root/ViewportContainer/Main")
onready var start_in_path := $StartInLevel/StartInPath


func _ready():
	start_in_path.text = DebugMode.get_value(STARTUP_SECTION, "level")


func _on_StartInPath_text_changed(new_text: String):
	DebugMode.save_value(STARTUP_SECTION, "level", new_text)


func _on_SetButton_pressed():
	var level_scene = main.level_scene
	if level_scene:
		var level_path = level_scene.resource_path
		start_in_path.text = level_path
		_on_StartInPath_text_changed(level_path)
