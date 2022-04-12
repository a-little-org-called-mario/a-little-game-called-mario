extends PanelContainer

const SPEED = 50.0

onready var scroll_container = $ScrollContainer
onready var vscroll = scroll_container.get_v_scrollbar()

func _ready():
	var label:Label = $ScrollContainer/VBoxContainer/Names
	var file = File.new()
	file.open("res://credits.txt", File.READ)
	label.text = file.get_as_text()

func _process(delta):
	vscroll.value += delta * SPEED

	if vscroll.value >= vscroll.max_value - scroll_container.rect_size.y:
		EventBus.emit_signal("change_scene", { "scene": "res://scenes/title/TitleScreen.tscn" })
