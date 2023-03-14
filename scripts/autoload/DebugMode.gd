extends Node

export(PackedScene) var root := preload("res://scenes/Main.tscn")
export(PackedScene) var menu_scene := preload("res://scenes/ui/DebugMenu.tscn")

const debug_settings_file_name := "user://debug.cfg"
const STARTUP_SECTION = "startup"

var menu : CanvasLayer = null
var config := ConfigFile.new()


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS #Can't pause this!
	var err := config.load(debug_settings_file_name)
	if err == OK: #The file exists
		var level = config.get_value(STARTUP_SECTION, "level", "")
		var data = config.get_value(STARTUP_SECTION, "data", {})
		if level:
			_start_level(level)
		if data:
			DataStore.data = data
			
			
func save_value(section, key, value):
	config.set_value(section, key, value)
	config.save(debug_settings_file_name)
	
	
func get_value(section, key, default=null):
	return config.get_value(section, key, default)


func _start_level(level: String):
	get_tree().change_scene_to(root)
	yield(get_tree(), "idle_frame")
	var main_scene := get_tree().current_scene
	var main := main_scene.get_node("ViewportContainer/Main")
	var level_scene := load(level)
	main._finish_level(level_scene)
	
	
func _input(event: InputEvent):
	if event.is_action_pressed("debug_button"):
		get_tree().set_input_as_handled()
		if menu:
			menu.queue_free()
			menu = null
			get_tree().paused = false
		else:
			menu = menu_scene.instance()
			add_child(menu)
			get_tree().paused = true
