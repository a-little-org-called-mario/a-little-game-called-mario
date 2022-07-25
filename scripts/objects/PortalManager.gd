extends Node2D


func _ready():
	EventBus.connect("show_all_portals", self, "_on_show_all")


func _on_show_all():
	for node in get_children():
		node.visible = true

