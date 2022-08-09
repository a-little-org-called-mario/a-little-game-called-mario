extends Control

export (PackedScene) var root
export (NodePath) onready var level_list = get_node(level_list) as ItemList
export (NodePath) onready var menu = get_node(menu) as Control
export (NodePath) onready var description = get_node(description) as RichTextLabel
export (NodePath) onready var preview_image = get_node(preview_image) as TextureRect
export (NodePath) onready var tags = get_node(tags) as Label


var main_scene = null


func _ready():
	EventBus.connect("hub_entered", self, "_exit_to_menu")
	level_list.grab_focus()
	level_list.connect("tree_entered", level_list, "grab_focus")


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


func _on_LevelList_item_activated(index: int) -> void:
	var metadata: LevelMetadata = level_list.get_item_metadata(index)
	_start_level(metadata.first_level_path)


func _on_LevelList_item_selected(index: int) -> void:
	var metadata: LevelMetadata = level_list.get_item_metadata(index)
	preview_image.texture = metadata.preview_image
	description.text = metadata.description
	var tags_text = ""
	if len(metadata.tags) > 0:
		tags_text = "[ %s ]" % PoolStringArray(metadata.tags).join(" ")
	tags.text = tags_text
