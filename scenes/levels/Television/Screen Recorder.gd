extends TextureRect

var frames = []
var last_step = 0
var recording = false
var playing = false
var pos = 0
export var delay = 1.0/60

export var id = "PlayButton"

func _ready() -> void:
	EventBus.connect("big_button_pressed", self, "react")

func react(button_id: String) -> void:
	if button_id != id:
		return
	recording = false
	playing = true
	visible = true


func _enter_tree():
	frames = []
	last_step = 0
	recording = true
	playing = false
	visible = false
	pos = 0
	rect_scale = Vector2(0.5, 0.5)

func _exit_tree():
	frames = []
	last_step = 0
	recording = false
	playing = false
	pos = 0
	
func _process(delta):
	if recording:
		last_step += delta
		if last_step > delay:
			last_step -= delay;
			var current_frame = get_viewport().get_texture().get_data()
			current_frame.flip_y()
			
			var tex = ImageTexture.new()
			tex.create_from_image(current_frame)
			
			frames.push_back(tex)
	if playing:
		if pos >=0 && pos < frames.size():
			texture = frames[pos]
			pos = pos + 1
		else:
			pos = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
