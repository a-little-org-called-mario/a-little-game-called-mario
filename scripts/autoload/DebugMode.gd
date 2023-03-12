extends Node

export(PackedScene) var root := preload("res://scenes/Main.tscn")
export(PackedScene) var menu_scene := preload("res://scenes/ui/DebugMenu.tscn")

const debug_settings_file_name := "user://debug.cfg"
const STARTUP_SECTION = "startup"

var menu : CanvasLayer = null
var config := ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var err := config.load(debug_settings_file_name)
	if err == OK: #The file exists
		var level = config.get_value(STARTUP_SECTION, "level", "")
		if level:
			_start_level(level)
			
			
func save_value(section, key, value):
	config.set_value(section, key, value)
	config.save(debug_settings_file_name)
	
	
func get_value(section, key):
	return config.get_value(section, key)


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
		else:
			menu = menu_scene.instance()
			add_child(menu)
