extends Camera2D

# The node that should be kept on-screen.
export var tracking : NodePath

onready var _tracking : Node2D = get_node(tracking)

func _process(_delta: float) -> void:
	position = _tracking.position.snapped(get_viewport_rect().size)
