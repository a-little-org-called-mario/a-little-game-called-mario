extends Area2D

export(NodePath) onready var dialogue_node


func _ready():
	if dialogue_node:
		dialogue_node = get_node_or_null(dialogue_node)
	connect("body_entered", self, "_body_entered")


func _body_entered(body):
	if (
		body.is_in_group("Player")
		and is_instance_valid(dialogue_node)
		and dialogue_node.has_method("auto_advance_dialogue")
	):
		dialogue_node.auto_advance_dialogue()
