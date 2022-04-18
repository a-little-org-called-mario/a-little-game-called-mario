# An enemy text that needs to be typed out
# Changes color for each hit character
extends Enemy
class_name TypeShootEnemy

const MAX_SPEED = 1

signal typed_out

onready var label: RichTextLabel = $NameLabel

var _target: Node2D
var _text: String
var _index: int

func set_target(target: Node2D) -> void:
	_target = target


func set_text(text: String) -> void:
	_index = 0
	_text = text.to_upper()
	_update_label()


func _update_label() -> void:
	# left is already typed out, right is the rest
	var left = _text.left(_index)
	var right = _text.substr(_index)
	label.bbcode_text = "[center][color=red]%s[/color]%s[/center]" % [left,right]


func move(_delta: float) -> void:
	if _target == null or not _target.is_inside_tree():
		return

	var dir = _target.global_position - global_position
	if dir.length_squared() < MAX_SPEED:
		return

	var collision = move_and_collide(dir.normalized() * MAX_SPEED)
	if collision:
		# Player was reached
		if collision.collider == _target:
			HeartInventoryHandle.change_hearts_on(_target, -1)
			queue_free()


func handle_input(input: String):
	# Check if the current input matches the target
	if _text[_index] != input:
		_index = 0
		_update_label()
	else:
		_index += 1
		_update_label()
		if _index >= _text.length():
			emit_signal("typed_out", self)
