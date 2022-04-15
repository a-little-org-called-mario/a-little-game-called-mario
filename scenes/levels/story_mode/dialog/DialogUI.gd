extends Control

signal dialog_finished
signal item_received(item)
signal event_occured(id)

export var inventory_path: NodePath

var active := false

var _item_store: ItemStore
var _dialog: Dialog
var _speaker: Character
var _current_text: int

const Dialog = preload("Dialog.gd")
const Character = preload("../character/Character.gd")
const ItemStore = preload("res://scenes/levels/story_mode/ItemStore.gd")

onready var _inventory := get_node(inventory_path)
onready var _dialog_text_label: RichTextLabel = $VBoxContainer/ColorRect/DialogTextLabel
onready var _continue_button: Button = $VBoxContainer/ColorRect/DialogTextLabel/ContinueButton
onready var _title_label: Label = $PortraitRect/VBoxContainer/TitleLabel
onready var _portrait_texture_rect: TextureRect = $PortraitRect/VBoxContainer/PortraitTextureRect
onready var _choice_container: VBoxContainer = $VBoxContainer/PanelContainer/ChoiceContainer
onready var _animation_player: AnimationPlayer = $AnimationPlayer

func set_items(to):
	_item_store = to


func start(speaker: Character, dialog: Dialog):
	_speaker = speaker
	_title_label.text = speaker.title
	_portrait_texture_rect.texture = speaker.get_portrait()
	_set_dialog(dialog)
	active = true


func _set_dialog(to: Dialog):
	_dialog = to
	visible = _dialog != null
	if not _dialog:
		active = false
		return emit_signal("dialog_finished")
	if to.is_condition:
		var condition = _inventory.has(_item_store.get(to.required_item))
		return _set_dialog(to.True if condition else to.False)
	for button in _choice_container.get_children():
		button.queue_free()
	for choice in _dialog.choices:
		var button := Button.new()
		button.text = choice
		button.connect("pressed", self, "_on_ChoiceButton_pressed",
				[_dialog.choices[choice]])
		_choice_container.add_child(button)
	_current_text = -1
	_progress_dialog()


func _progress_dialog():
	_current_text += 1
	_dialog_text_label.text = tr(_dialog.text[_current_text])
	var last : bool = _current_text == _dialog.text.size() - 1
	_continue_button.visible = not last
	_choice_container.visible = last
	if last:
		if _dialog.item:
			emit_signal("item_received", _dialog.item)
		if _dialog.event:
			emit_signal("event_occured", _dialog.event)
		if _dialog.new_sprite:
			_speaker.set_sprite(_dialog.new_sprite)
	_animation_player.play("talking")


func _on_ChoiceButton_pressed(choice):
	_set_dialog(choice)


func _on_ContinueButton_pressed() -> void:
	_progress_dialog()
