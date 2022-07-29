extends Control

export (PackedScene) var root
export (NodePath) onready var level_list = get_node(level_list) as ItemList
export (NodePath) onready var menu = get_node(menu) as Control

var main_scene = null


func _ready():
	EventBus.connect("hub_entered", self, "_exit_to_menu")


func _on_StartButton_pressed():
	var metadata: LevelMetadata = null
	for level in level_list.get_selected_items():
		metadata = level_list.get_item_metadata(level)
		break
	if not metadata:
		return
	_start_level(metadata.first_level_path)


func _start_level(next_level):
	main_scene = root.instance()
	var main = main_scene.get_node("ViewportContainer/Main")
	main.level_scene = load(next_level)
	add_child(main_scene)
	remove_child(menu)


func _exit_to_menu():
	main_scene.queue_free()
	add_child(menu)


func _on_LevelList_item_activated(index):
	var metadata: LevelMetadata = level_list.get_item_metadata(index)
	_start_level(metadata.first_level_path)
