tool
extends Area2D

"""
An interactable NPC.

The dialog is started when pressing the interact button when close
to this character.

When instancing, enable editable children and change the collision
shape, sprite and interact label. The %s in the label will be replaced
by the character name.
"""

# Emitted when the player goes up to the character and presses
# the interact key.
signal talked_to

export var data: Resource setget _set_data
export var talk_to_text := "Talk to %s" setget _set_talk_to_text

# The dialog json file that is shown when talking to this character.
# warning-ignore:unused_class_variable
export var dialog: Resource setget _set_dialog

onready var _sprite: Sprite = $Sprite
onready var _talk_to_label: Label = $TalkToLabel


func _get_configuration_warning() -> String:
	if not data is StoryCharacterData:
		return "Character data not set"
	return ""


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("interact") and get_overlapping_bodies():
		emit_signal("talked_to")


# Returns the current texture of the NPC.
func get_portrait() -> Texture:
	return _sprite.texture


func _set_data(to: StoryCharacterData):
	data = to
	update_configuration_warning()
	if to:
		_set_talk_to_text(talk_to_text)
		$Sprite.texture = to.texture


func _set_talk_to_text(to):
	talk_to_text = to
	if data:
		var text: String = "[Q] %s" % tr(talk_to_text)
		if "%s" in text:
			text = text % data.name
		$TalkToLabel.text = text


func _set_dialog(to):
	dialog = to
	$TalkToLabel.visible = Engine.is_editor_hint() and to


func _on_body_entered(_body: Node) -> void:
	_talk_to_label.visible = dialog != null


func _on_body_exited(_body: Node) -> void:
	_talk_to_label.hide()
