extends Control

"""
Dialog for displaying interactions with characters.
"""

signal dialog_started
signal dialog_finished
# Emitted when the player receives an item during a dialog.
signal item_received(item)
# Emitted when a dialog emits an event. The event is a string.
# The event is then handled by the main script.
signal event_occured(id)


export(PackedScene) var dialog_button


# True if the player is currently in a dialog.
var active := false

var _dialogs: Dictionary
# Reached labels inside the current dialog.
var _labels: Dictionary
var _inventory: Inventory
var _item_store: ItemStore
var _dialog: Dialog
var _speaker: Character
var _current_text: int
# A dictionary storing how often a certain dialog has been reached.
var _occurences: Dictionary
# The name of the dialog that is being checked for issues.
var _checking: String
var _characters: Characters

const Dialog = preload("res://addons/dialog_importer/dialog.gd")
const Condition = preload("res://addons/dialog_importer/condition.gd")
const Choice = preload("res://addons/dialog_importer/choice.gd")
const Character = preload("../character/Character.gd")
const ItemStore = preload("../item/ItemStore.gd")
const FileUtils = preload("res://scripts/FileUtils.gd")
const Inventory = preload("../item/Inventory.gd")
const Characters = preload("res://scenes/levels/story_mode/Characters.gd")

onready var _dialog_text_label: RichTextLabel = $ColorRect/MarginContainer/VBoxContainer/DialogTextLabel
onready var _continue_button: Button = $ColorRect/MarginContainer/VBoxContainer/DialogTextLabel/ContinueButton
onready var _finish_button: Button = $ColorRect/MarginContainer/VBoxContainer/DialogTextLabel/FinishButton
onready var _title_label: Label = $PortraitRect/VBoxContainer/TitleLabel
onready var _portrait_texture_rect: TextureRect = $PortraitRect/VBoxContainer/PortraitTextureRect
onready var _choice_container: VBoxContainer = $ColorRect/MarginContainer/VBoxContainer/ChoiceContainer
onready var _animation_player: AnimationPlayer = $AnimationPlayer


func init(item_store: ItemStore, characters: Characters, inventory: Inventory,
		dialog_dir: String):
	_item_store = item_store
	_inventory = inventory
	_characters = characters
	for file in FileUtils.list_dir(dialog_dir):
		if not file.ends_with(".json.import"):
			continue
		file = file.replace(".import", "")
		var dialog = load(file)
		_dialogs[file.get_file().get_basename()] = dialog
	for dialog_name in _dialogs:
		_labels.clear()
		_gather_labels(_dialogs[dialog_name])
		_checking = dialog_name
		_check_dialog(_dialogs[dialog_name])


# Start a dialog with optionally a character as speaker.
func start(dialog: Dialog, speaker: Character = null):
	_assert_ready()
	active = true
	emit_signal("dialog_started")
	_labels.clear()
	_gather_labels(dialog)
	_set_dialog(dialog)
	_set_speaker(speaker)


func _set_speaker(speaker: Character):
	_speaker = speaker
	if not speaker:
		_portrait_texture_rect.texture = null
		_title_label.text = ""
		return
	_title_label.text = _speaker.data.name
	_portrait_texture_rect.texture = _speaker.get_portrait()


func _set_dialog(to: Dialog):
	_dialog = to
	visible = _dialog != null
	if not _dialog:
		active = false
		return emit_signal("dialog_finished")
	if _dialog.character:
		var character: Character = _characters.get_by_id(_dialog.character)
		assert(character, "Character '%s' not found" % _dialog.character)
		_set_speaker(character)
	if _dialog.condition:
		var condition := _condition_true(_dialog.condition, _dialog)
		if _dialog.has_branches:
			return _set_dialog(_dialog.True if condition else _dialog.False)
		if not condition:
			return _set_dialog(null)
	for button in _choice_container.get_children():
		_choice_container.remove_child(button)
		button.queue_free()
	for choice in _dialog.choices:
		var button := dialog_button.instance() as BaseMenuButton
		button.text = choice.text
		var dialog := _evaluate_dialog(choice.dialog)
		if choice.dialog and not dialog:
			continue
		if choice.condition and not _condition_true(choice.condition, choice):
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
	if _finish_button.visible:
		_finish_button.grab_focus()
	elif _continue_button.visible:
		_continue_button.grab_focus()
	elif _choice_container.get_child_count():
		_choice_container.get_child(0).grab_focus()
	if last:
		_occurences[_dialog] = _occurences.get(_dialog, 0) + 1
		if _dialog.item:
			emit_signal("item_received", _dialog.item)
		if _dialog.event:
			emit_signal("event_occured", _dialog.event)
	_animation_player.stop()
	_animation_player.play("talking")


func _condition_true(condition: Condition, object: Object) -> bool:
	var checks := []
	if condition.required_item:
		var item = _item_store.get(condition.required_item)
		assert(item, "Couldn't find item %s" % condition.required_item)
		checks.append(_inventory.has(item))
	if condition.only_at_occurence:
		var occurence := condition.only_at_occurence - 1
		checks.append(_occurences.get(object, 0) == occurence)
	if condition.custom:
		assert(not condition.custom or owner.has_method(condition.custom),
				"Can't find custom condition method '%s' in main script."\
				% condition.custom)
		checks.append(owner.call(condition.custom))
	for check in checks:
		if check == condition.inverted:
			return false
	return true


func _gather_labels(dialog):
	if not dialog:
		return
	if dialog.label:
		_labels[dialog.label] = dialog
	for branch in [dialog.True, dialog.False]:
		_gather_labels(branch)
	for choice in dialog.choices:
		_gather_labels(choice.dialog)


# Returns the dialog that should be displayed when this dialog object is hit.
func _evaluate_dialog(dialog: Dialog) -> Dialog:
	if not dialog:
		return null
	if dialog.condition:
		if _condition_true(dialog.condition, dialog):
			if dialog.True:
				return dialog.True as Dialog
		else:
			return dialog.False as Dialog
	if dialog.goto:
		return _evaluate_dialog(_labels[dialog.goto])
	return dialog


# Skip the dialog and return if the dialog needed to be skipped.
func _skip_dialog() -> bool:
	if _dialog_text_label.visible_characters\
			< _dialog_text_label.text.length():
		_animation_player.seek(100, true)
		return true
	return false


# Check this dialog and the contained conditions/dialogs for any issues.
func _check_dialog(dialog):
	if not dialog:
		return
	_check_condition(dialog.condition)
	if dialog.goto:
		_check_assert(dialog.goto in _labels,
				"Couldn't find label %s to go to.", dialog.goto)
	for branch in [dialog.True, dialog.False]:
		_check_dialog(branch)
	for _choice in dialog.choices:
		var choice: Choice = _choice
		_check_condition(choice.condition)
		_check_dialog(choice.dialog)


# Check if the condition is valid.
func _check_condition(condition: Condition):
	if not condition:
		return
	if condition.required_item:
		_check_assert(_item_store.get(condition.required_item),
				"Couldn't find item %s", condition.required_item)
	if condition.custom:
		_check_assert(owner.has_method(condition.custom),
				"Can't find custom condition method '%s' in main script.",
				condition.custom)


# An assert that prepends the dialog name to the message.
func _check_assert(condition, message: String, format):
	assert(condition, "Dialog '%s': %s" % [_checking, message % format])


func _on_ChoiceButton_pressed(choice: Dialog):
	_set_dialog(choice)


func _assert_ready():
	assert(_item_store and _inventory, "Inventory and item provider not set.")


func _on_ContinueButton_pressed() -> void:
	if not _skip_dialog():
		_progress_dialog()


func _on_FinishButton_pressed() -> void:
	if not _skip_dialog():
		_set_dialog(_dialog.next)
