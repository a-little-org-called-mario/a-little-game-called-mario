extends Node

export(PackedScene) var root := preload("res://scenes/Main.tscn")
export(PackedScene) var menu_scene := preload("res://scenes/ui/DebugMenu.tscn")

var menu : CanvasLayer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_startup("res://scenes/levels/Default/Level03.tscn")


func _startup(level: String):
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
