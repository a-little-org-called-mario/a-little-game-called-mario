extends AnimationPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func playAnim(strIn = "Idle"):
	if strIn != self.current_animation:
		self.play(strIn)
