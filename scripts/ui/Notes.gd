extends CanvasLayer


var pages = {}

export (PackedScene) var noteButton

onready var _list := $Hbox/Scroll/VBox
onready var _sprite := $Hbox/VBox/Panel/Sprite
onready var _name := $Hbox/VBox/Center/Name
onready var _desc := $Hbox/VBox/Center2/Description
onready var _hbox := $Hbox
onready var _exit := $Exit


func _ready():
	$Hbox.visible = false
	$Exit.visible = false
	EventBus.connect("note_added", self, "_on_note_added")
	remove_pages()


func _process(delta):
	if Input.is_action_just_pressed("show_notes") or (Input.is_action_just_pressed("pause") and _hbox.visible):
		toggle_visible()


func toggle_visible():
	if _hbox.visible:
		_hbox.visible = false
		_exit.visible = false
		get_tree().paused = false
	elif get_tree().paused == false:
		_hbox.visible = true
		_exit.visible = true
		if _list.get_child_count() > 0:
			_list.get_child(0).grab_focus()
		get_tree().paused = true


func remove_pages():
	for node in _list.get_children():
		node.queue_free()


func add_page(name, desc, sprite, spriteScale):
	pages[name] = {"desc": desc, "sprite" : sprite, "scale" : spriteScale}


func add_button(name):
	var button = noteButton.instance()
	button.text = name
	button.connect("page_changed", self, "_on_page_changed")
	_list.add_child(button)


func _on_note_added(name, desc, sprite, spriteScale):
	if not pages.has(name):
		add_button(name)
	add_page(name, desc, sprite, spriteScale)


func _on_page_changed(pageName):
	var pageInfo = pages.get(pageName)
	_name.text = pageName
	_desc.text = pageInfo.desc
	_sprite.animation = pageInfo.sprite
	_sprite.scale = pageInfo.scale


func _on_Exit_pressed():
	toggle_visible()

