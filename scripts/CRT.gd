extends Node

export(NodePath) var container_path: NodePath

onready var container: ViewportContainer = get_node(container_path)
onready var crt_shader: Shader = preload("res://shaders/CRT.gdshader")


func _ready():
	EventBus.connect("crt_filter_toggle", self, "_on_crt_toggle")
	_on_crt_toggle(Settings.crt_filter)


func _on_crt_toggle(on: bool) -> void:
	if on:
		container.material.shader = crt_shader
	else:
		container.material.shader = null
