extends PanelContainer

const DEFAULT_SPEED = 50.0
const FAST_SPEED = 300.0

onready var contributors: Contributors = preload("res://scenes/title/Contributors.gd").new()
onready var scroll_container = $ScrollContainer
onready var vscroll = scroll_container.get_v_scrollbar()


func _ready():
	var label: Label = $ScrollContainer/VBoxContainer/Names
	label.text = contributors.get_text()


func _process(delta):
	if Input.is_action_pressed("jump"):
		vscroll.value += delta * FAST_SPEED
	else:
		vscroll.value += delta * DEFAULT_SPEED

	if (
		vscroll.value >= vscroll.max_value - scroll_container.rect_size.y
		|| Input.is_action_pressed("pause")
	):
		EventBus.emit_signal("change_scene", {"scene": "res://scenes/title/TitleScreen.tscn"})
