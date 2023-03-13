extends Control

const STARTUP_SECTION = "startup"

onready var main := get_node_or_null("/root/Root/ViewportContainer/Main")
onready var start_path := $StartLevel/StartPath
onready var data_set_button := $StartData/SetButton
onready var data_clear_button := $StartData/ClearButton


func _ready():
	start_path.text = DebugMode.get_value(STARTUP_SECTION, "level", "")


func _on_StartPath_text_changed(new_text: String):
	DebugMode.save_value(STARTUP_SECTION, "level", new_text)


func _on_SetButton_pressed():
	if main: #The main scene may not be loaded in some cases
		var level_scene = main.level_scene
		if level_scene:
			var level_path = level_scene.resource_path
			start_path.text = level_path
			_on_StartPath_text_changed(level_path)


func _on_DataSetButton_pressed():
	DebugMode.save_value(STARTUP_SECTION, "data", DataStore.data)
	data_set_button.text = "Saved!"
	data_clear_button.text = "Clear"


func _on_DataClearButton_pressed():
	DebugMode.save_value(STARTUP_SECTION, "data", null)
	data_set_button.text = "Save"
	data_clear_button.text = "Cleared!"


func _on_LevelClearButton_pressed():
	start_path.text = ""
	DebugMode.save_value(STARTUP_SECTION, "level", null)
