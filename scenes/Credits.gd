extends PanelContainer

const SPEED = 50.0

onready var scroll_container = $ScrollContainer
onready var vscroll = scroll_container.get_v_scrollbar()

func _process(delta):
	vscroll.value += delta * SPEED
	
	if vscroll.value >= vscroll.max_value - scroll_container.rect_size.y:
		get_tree().change_scene("res://scenes/Main.tscn")
