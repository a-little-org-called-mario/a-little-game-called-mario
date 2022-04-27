extends Camera2D

"""
Camera used for cutscenes.

Moves smoothly to the CutSceneFocus node, which is set
to the player position at the start of a cutscene.
"""

export var focus_path : NodePath = @"../CutSceneFocus"

onready var _focus : Position2D = get_node(focus_path)

func _process(delta: float) -> void:
	position = lerp(position, _focus.position, delta * 4)
