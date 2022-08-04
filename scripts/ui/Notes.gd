extends CanvasLayer


var pages = {}

const notes_file_name = "user://notes.mario"

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
	load_notes()


func _unhandled_key_input(event):
	if Input.is_action_just_pressed("show_notes") or (Input.is_action_just_pressed("pause") and _hbox.visible):
		toggle_visible()


func toggle_visible():
	if _hbox.visible:
		_hbox.visible = false
		_exit.visible = false
		get_tree().paused = false
		EventBus.emit_signal("notes_closed")
	elif get_tree().paused == false:
		_hbox.visible = true
		_exit.visible = true
		if _list.get_child_count() > 0:
			_list.get_child(0).grab_focus()
		EventBus.emit_signal("notes_opened")
		get_tree().paused = true


func remove_pages():
	for node in _list.get_children():
		node.queue_free()


func add_page(name, desc, sprite, spriteScale):
	pages[name] = {"desc": desc, "sprite" : sprite, "scale" : spriteScale}
	save_notes()


func add_button(name):
	var button = noteButton.instance()
	button.text = name
	button.connect("page_changed", self, "_on_page_changed")
	_list.add_child(button)


func _on_note_added(name, desc, sprite, spriteScale, from_load: bool = false) -> void:
	if not pages.has(name):
		add_button(name)
		if not from_load:
			EventBus.emit_signal("notes_updated")
	add_page(name, desc, sprite, spriteScale)


func _on_page_changed(pageName):
	var pageInfo = pages.get(pageName)
	_name.text = pageName
	_desc.text = pageInfo.desc
	_sprite.animation = pageInfo.sprite
	_sprite.scale = pageInfo.scale


func _on_Exit_pressed():
	toggle_visible()

func save_notes():
	var notes_file = File.new()
	notes_file.open(notes_file_name, File.WRITE)
	notes_file.store_line(to_json(pages))
	notes_file.close()

func load_notes():
	var notes_file = File.new()

	# there is no notes.mario :(
	if not notes_file.file_exists(notes_file_name) or notes_file.open(notes_file_name, File.READ) != OK:
		return
	# access notes.mario and read saved notes
	
	var all_pages = parse_json(notes_file.get_line())
	for page_name in all_pages.keys():
		var page = all_pages[page_name]

		# NOTE(jam): godot's json parsing can convert vector2 TO string, but not the other way around
		var scale_str: String = page.scale
		scale_str.erase(0, 1)
		scale_str.erase(scale_str.length() - 1, 1)
		var scale_arr = scale_str.split(", ")

		_on_note_added(
			page_name, page.desc, page.sprite,
			Vector2(scale_arr[0], scale_arr[1]),
			true
		)

func delete_all_notes():
	pages = {}
	remove_pages()
	save_notes() # NOTE (jam): should be less hassle to overwrite file with an empty json object
				 # than deleting the cookie and then later recreating the cookie and so on
