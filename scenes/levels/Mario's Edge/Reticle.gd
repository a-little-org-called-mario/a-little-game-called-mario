extends Sprite

func _ready():
	center()


func center():
	self.position = get_viewport_rect().get_center()
