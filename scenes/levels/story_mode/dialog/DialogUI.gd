extends Control

signal dialog_finished

var dialog : Dialog setget _set_dialog
var _current_text : int

const Dialog = preload("Dialog.gd")
const Character = preload("../character/Character.gd")

onready var _dialog_text_label: RichTextLabel = $VBoxContainer/ColorRect/DialogTextLabel
onready var _continue_button: Button = $VBoxContainer/ColorRect/DialogTextLabel/ContinueButton
onready var _title_label: Label = $PortraitRect/VBoxContainer/TitleLabel
onready var _portrait_texture_rect: TextureRect = $PortraitRect/VBoxContainer/PortraitTextureRect
onready var _choice_container: VBoxContainer = $VBoxContainer/PanelContainer/ChoiceContainer
onready var _animation_player: AnimationPlayer = $AnimationPlayer

func set_speaker(character: Character):
	_title_label.text = character.title
	_portrait_texture_rect.texture = character.get_portrait()


func _set_dialog(to):
	dialog = to
	visible = dialog != null
	if not dialog:
		return emit_signal("dialog_finished")
	for button in _choice_container.get_children():
		button.queue_free()
	for choice in dialog.choices:
		var button := Button.new()
		button.text = choice
		button.connect("pressed", self, "_on_ChoiceButton_pressed", [dialog.choices[choice]])
		_choice_container.add_child(button)
	_current_text = -1
	_progress_dialog()


func _progress_dialog():
	_current_text += 1
	_dialog_text_label.text = tr(dialog.text[_current_text])
	var last := _current_text == dialog.text.size() - 1
	_continue_button.visible = not last
	_choice_container.visible = last
	_animation_player.play("talking")


func _on_ChoiceButton_pressed(choice):
	_set_dialog(choice)


func _on_ContinueButton_pressed() -> void:
	_progress_dialog()
