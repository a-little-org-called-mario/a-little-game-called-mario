extends TextureRect

export var id = "PlayButton"

var frames = []
var recording = false
var playing = false
var pos = 0


func _ready() -> void:
	EventBus.connect("big_button_pressed", self, "react")


func react(button_id: String) -> void:
	if button_id != id:
		return
	recording = false
	playing = true
	self.visible = true


func _enter_tree():
	frames = []
	recording = true
	playing = false
	self.visible = false
	pos = 0


func _exit_tree():
	frames = []
	recording = false
	playing = false
	pos = 0


func _on_Timer_timeout():
	if recording:
		var current_frame = get_viewport().get_texture().get_data()
		var tex = ImageTexture.new()
		tex.create_from_image(current_frame)
		frames.push_back(tex)
	elif playing:
		if pos >=0 && pos < frames.size():
			self.texture = frames[pos]
			pos = pos + 1
		else:
			pos = 0
