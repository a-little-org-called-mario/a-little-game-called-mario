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

# The name of this character.
export var title : String

# The dialog json file that is shown when talking to this character.
export var dialog : String

onready var _sprite: Sprite = $Sprite
onready var _talk_to_label: Label = $TalkToLabel


func _ready() -> void:
	_talk_to_label.text %= title
	_talk_to_label.hide()


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("fire") and get_overlapping_bodies():
		emit_signal("talked_to")


# Changes how the NPC looks.
func set_sprite(to):
	_sprite.texture = to


# Returns the current texture of the NPC.
func get_portrait() -> Texture:
	return _sprite.texture


func _on_body_entered(_body: Node) -> void:
	_talk_to_label.show()


func _on_body_exited(_body: Node) -> void:
	_talk_to_label.hide()
