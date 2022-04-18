extends Control

"""
Dialog for displaying interactions with characters.
"""

signal dialog_finished
# Emitted when the player receives an item during a dialog.
signal item_received(item)
# Emitted when a dialog emits an event. The event is a string.
# The event is then handled by the main script.
signal event_occured(id)

# True if the player is currently in a dialog.
var active := false

var _dialogs: Dictionary
var _inventory: Inventory
var _item_store: ItemStore
var _dialog: Dialog
var _speaker: Character
var _current_text: int
# A dictionary storing how often a certain dialog has been reached.
var _occurences: Dictionary

const Dialog = preload("Dialog.gd")
const Character = preload("../character/Character.gd")
const ItemStore = preload("../items/ItemStore.gd")
const FileUtils = preload("res://scripts/FileUtils.gd")
const Inventory = preload("../items/Inventory.gd")

onready var _dialog_text_label: RichTextLabel = $ColorRect/MarginContainer/VBoxContainer/DialogTextLabel
onready var _continue_button: Button = $ColorRect/MarginContainer/VBoxContainer/DialogTextLabel/ContinueButton
onready var _finish_button: Button = $ColorRect/MarginContainer/VBoxContainer/DialogTextLabel/FinishButton
onready var _title_label: Label = $PortraitRect/VBoxContainer/TitleLabel
onready var _portrait_texture_rect: TextureRect = $PortraitRect/VBoxContainer/PortraitTextureRect
onready var _portrait_rect: ColorRect = $PortraitRect
onready var _choice_container: VBoxContainer = $ColorRect/MarginContainer/VBoxContainer/PanelContainer/ChoiceContainer
onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	var dialog_dir: String = get_script().resource_path\
			.get_base_dir().plus_file("../dialogs")
	for file in FileUtils.list_dir(dialog_dir):
		var data := FileUtils.as_json(file)
		if not data:
			push_error("Couldn't load dialog %s" % [file])
		_dialogs[file.get_file().get_basename()] = Dialog.new(data)


func set_items(to: ItemStore):
	_item_store = to


func set_inventory(to: Inventory):
	_inventory = to


# Start a dialog with optionally a character as speaker.
func start(dialog: String, speaker: Character = null):
	assert(_item_store and _inventory, "Inventory and item provider not set.")
	assert(dialog in _dialogs, "Dialog %s not found" % dialog)
	_speaker = speaker
	_title_label.text = ""
	_portrait_rect.visible = speaker != null
	if _speaker:
		_title_label.text = _speaker.title
		_portrait_texture_rect.texture = _speaker.get_portrait()
	_set_dialog(_dialogs[dialog])
	active = true


func _set_dialog(to: Dialog):
	_dialog = to
	visible = _dialog != null
	if not _dialog:
		active = false
		return emit_signal("dialog_finished")
	if _dialog.has_condition:
		var condition := _condition_true(_dialog)
		if _dialog.has_branches:
			return _set_dialog(_dialog.True if condition else _dialog.False)
		if not condition:
			return _set_dialog(null)
	for button in _choice_container.get_children():
		button.queue_free()
	for choice in _dialog.choices:
		var button := Button.new()
		button.text = choice
		var dialog: Dialog = _dialog.choices[choice]
		if not _condition_true(dialog) and not dialog.has_branches:
			continue
		button.connect("pressed", self, "_on_ChoiceButton_pressed", [dialog])
		_choice_container.add_child(button)
	_current_text = -1
	_progress_dialog()


# Move to the next item inside the current dialog.
func _progress_dialog():
	_current_text += 1
	_dialog_text_label.text = tr(_dialog.text[_current_text])
	var last : bool = _current_text == _dialog.text.size() - 1
	_continue_button.visible = not last
	_choice_container.visible = last
	_finish_button.visible = _dialog.choices.empty() and last
	if last:
		_occurences[_dialog] = _occurences.get(_dialog, 0) + 1
		if _dialog.item:
			emit_signal("item_received", _dialog.item)
		if _dialog.event:
			emit_signal("event_occured", _dialog.event)
		if _dialog.new_sprite:
			assert(_speaker, "Can't change sprite in dialog without speaker.")
			_speaker.set_sprite(_dialog.new_sprite)
	_animation_player.stop()
	_animation_player.play("talking")


func _condition_true(dialog: Dialog) -> bool:
	if not dialog or not dialog.has_condition:
		return true
	var item = not dialog.required_item or _inventory.has(_item_store.get(
			dialog.required_item))
	var occurence = not dialog.only_at_occurence or\
			_occurences.get(dialog, 0) == dialog.only_at_occurence - 1
	return item and occurence


# Skip the dialog and return if the dialog needed to be skipped.
func _skip_dialog() -> bool:
	_animation_player.seek(100, true)
	return _animation_player.is_playing()


func _on_ChoiceButton_pressed(choice: Dialog):
	_set_dialog(choice)


func _on_ContinueButton_pressed() -> void:
	if not _skip_dialog():
		_progress_dialog()


func _on_FinishButton_pressed() -> void:
	if not _skip_dialog():
		_set_dialog(null)
