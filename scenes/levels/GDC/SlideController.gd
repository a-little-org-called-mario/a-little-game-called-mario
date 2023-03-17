extends AnimatedSprite


func _ready():
	frame = 0


func _process(_delta):
	if (Input.is_action_just_pressed("right")):
		update_slide(1)

	if (Input.is_action_just_pressed("left")):
		update_slide(-1)


func update_slide(dir):
	for node in get_child(frame).get_children():
		if dir == 1 and not node.visible:
			node.show()
			return
		elif dir == -1 and node.visible:
			node.hide()
			return

	if dir == 1:
		get_child(frame).hide()
		frame += 1
		get_child(frame).show()
	elif dir == -1:
		get_child(frame).hide()
		frame -= 1
		get_child(frame).show()
