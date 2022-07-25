extends Control

export (NodePath) var texture_nodepath

onready var texture_rect: TextureRect = get_node(texture_nodepath) as TextureRect


func show_icon():
	texture_rect.modulate.a = 1


func hide_icon():
	texture_rect.modulate.a = 0


func select():
	modulate.v = 1


func deselect():
	modulate.v = 0.66

