extends ScrollContainer
export(float, 10.0, 1000.0) var scroll_speed

func _ready():
	# We don't want to see the scrollbar
	get_h_scrollbar().modulate = Color(0, 0, 0, 0)

func _process(delta):
	var bar := get_h_scrollbar()
	bar.value += delta * scroll_speed
	if bar.value >= bar.max_value - rect_size.x:
		bar.value = 0
