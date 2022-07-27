extends CanvasLayer


var pages = {
	"Little Mario" : {
		"desc":"Hey, that's me, Little Mario! This is where I make notes about my adventures! As I meet new people and make new discoveries, I'm going to make sure to write all about them here!", 
		"sprite":"little_mario",
		"scale":Vector2(2, 2)
	}
}

var noteButton = preload("res://scenes/ui/NotesButton.tscn")
var nextPageID = 0

onready var _list := $Hbox/Scroll/VBox
onready var _sprite := $Hbox/VBox/Panel/Sprite
onready var _name := $Hbox/VBox/Center/Name
onready var _desc := $Hbox/VBox/Center2/Description
onready var _hbox := $Hbox


func _ready():
	$Hbox.visible = false
	EventBus.connect("note_added", self, "_on_note_added")
	remove_pages()
	add_button("Little Mario")
	_on_page_changed("Little Mario")


func _process(delta):
	if Input.is_action_just_pressed("show_notes"):
		toggle_visible()


func toggle_visible():
	if _hbox.visible:
		_hbox.visible = false
		get_tree().paused = false
	elif get_tree().paused == false:
		_hbox.visible = true
		_list.get_child(0).grab_focus()
		get_tree().paused = true


func remove_pages():
	for node in _list.get_children():
		node.queue_free()


func add_page(name, desc, sprite, spriteScale):
	pages[name] = {"desc": desc, "sprite" : sprite, "scale" : spriteScale}
	add_button(name)


func add_button(name):
	var button = noteButton.instance()
	button.text = name
	button.connect("page_changed", self, "_on_page_changed")
	_list.add_child(button)


func _on_note_added(name, desc, sprite, spriteScale):
	# prevent duplicates
	var found = false
	for page in pages.keys():
		if page == name:
			found = true
	
	# add a new page
	if not found:
		add_page(name, desc, sprite, spriteScale)


func _on_page_changed(pageName):
	var pageInfo = pages.get(pageName)
	_name.text = pageName
	_desc.text = pageInfo.desc
	_sprite.animation = pageInfo.sprite
	_sprite.scale = pageInfo.scale

