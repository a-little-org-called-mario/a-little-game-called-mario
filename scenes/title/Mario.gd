extends Sprite

#func _ready():
# pass


func _process(delta):
	if Input.is_action_just_pressed("click"):
		if get_rect().has_point(to_local(get_global_mouse_position())):
			$Meow.play()
