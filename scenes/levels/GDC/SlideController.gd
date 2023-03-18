extends AnimatedSprite


export (NodePath) var intro_gate


func _ready():
	print("started")
	EventBus.emit_signal("ui_visibility_changed", false)
	EventBus.emit_signal("heart_changed", 999, 999)
	EventBus.emit_signal("bgm_changed", {"playing": false})
	frame = 0


func _process(_delta):
	# only control slides if mario has not yet been unleashed
	if get_node_or_null(intro_gate):
		if (Input.is_action_just_pressed("right")):
			update_slide(1)

		if (Input.is_action_just_pressed("left")):
			update_slide(-1)


func update_slide(dir):
	var current_slide_extras = get_child(frame)
	var last_extra_index = current_slide_extras.get_child_count() - 1

	# all slides have been shown. release the little mario
	if frame >= frames.get_frame_count(animation) - 1 and current_slide_extras.get_child(last_extra_index).visible:
		get_node(intro_gate).queue_free()
		EventBus.emit_signal("bgm_changed", {"playing": true})
		return

	# show/hide next/last subelement
	for node in get_child(frame).get_children():
		if dir == 1 and not node.visible:
			node.show()
			return
		elif dir == -1 and node.visible:
			node.hide()
			return

	# show/hide next/last slide
	if dir == 1:
		get_child(frame).hide()
		frame += 1
		get_child(frame).show()
	elif dir == -1:
		get_child(frame).hide()
		frame -= 1
		get_child(frame).show()
