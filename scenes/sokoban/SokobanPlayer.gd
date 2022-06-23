extends KinematicBody2D
class_name SokobanPlayer


signal player_moved(to_dir)


const inputs = {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}


func _ready():
	pass


func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			emit_signal("player_moved", inputs.get(dir, Vector2.ZERO))
			break
