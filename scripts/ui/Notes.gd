extends CanvasLayer


var pages = [{"name":"Little Mario",
"desc":"Hey, that's me, Little Mario! This is where I make notes about my adventures! As I meet new people and make new discoveries, I'm going to make sure to write all about them here!", 
"sprite":"little_mario"}]

var noteButton = preload("res://scenes/ui/NotesButton.tscn")
var nextPageID = 0

onready var _list := $Hbox/Scroll/VBox
onready var _sprite := $Hbox/VBox/Panel/Sprite
onready var _name := $Hbox/VBox/Center/Name
onready var _desc := $Hbox/VBox/Center2/Description
onready var _hbox := $Hbox


func _ready():
	$Hbox.visible = false
	EventBus.connect("add_to_notes", self, "_on_add_to_notes")
	remove_pages()
	add_button()
	_on_change_page(0)


func _process(delta):
	toggle_visible()


func toggle_visible():
	if Input.is_action_just_pressed("show_notes"):
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


func add_page(name, desc, sprite):
	var newPage = {"name":name, "desc":desc, "sprite":sprite}
	pages.append(newPage)


func add_button():
	var button = noteButton.instance()
	button.text = pages[nextPageID].name
	button.pageID = nextPageID
	button.connect("change_page", self, "_on_change_page")
	_list.add_child(button)
	nextPageID += 1


func reset_focus():
	# reseting the focus path for the buttons
	var buttons = []
	for node in _list.get_children():
		buttons.append(node)
	
	for i in len(buttons):
		if i != 0:
			buttons[i].focus_neighbour_top = buttons[i-1].get_path()
		if i != len(buttons)-1:
			buttons[i].focus_neighbour_bottom = buttons[i+1].get_path()


func _on_add_to_notes(name, desc, sprite):
	# prevent duplicates
	var found = false
	for page in pages:
		if page.name == name:
			found = true
	
	# add a new page
	if not found:
		add_page(name, desc, sprite)
		add_button()
		reset_focus()


func _on_change_page(pageID):
	_name.text = pages[pageID].name
	_desc.text = pages[pageID].desc
	_sprite.animation = pages[pageID].sprite

