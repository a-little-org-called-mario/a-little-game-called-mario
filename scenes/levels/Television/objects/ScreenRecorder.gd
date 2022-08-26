extends TextureRect

export(float) var delay = 1.0/60.0
export var id = "PlayButton"

var frames = []
var last_step = 0
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
	last_step = 0
	recording = true
	playing = false
	self.visible = false
	pos = 0


func _exit_tree():
	frames = []
	last_step = 0
	recording = false
	playing = false
	pos = 0


func _physics_process(delta: float) -> void:
	if recording:
		last_step += delta
		if last_step > delay:
			last_step -= delay;
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
