extends Label


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var secondsUntilDisappearing = 5;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _process(delta: float) -> void:
	if visible:
		secondsUntilDisappearing -= delta;
	if secondsUntilDisappearing < 0:
		queue_free();


func reveal() -> void:
	visible = true;
