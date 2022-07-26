extends VBoxContainer

signal tab_changed(idx)

export (int, 0, 99) var current_tab: int = 0

export (NodePath) var tabs_nodepath
export (NodePath) var panels_nodepath

onready var tabs: Control = get_node(tabs_nodepath) as Control
onready var panels: Control = get_node(panels_nodepath) as Control


func _ready() -> void:
	current_tab = clamp(current_tab, 0, tabs.get_child_count())
	
	for idx in tabs.get_child_count():
		var tab = tabs.get_child(idx)
		tab.connect("focus_entered", self, "_on_tab_changed", [idx])

	var tab = tabs.get_child(current_tab)
	if tab and tab.has_method("grab_focus"):
		tab.grab_focus()


func _on_tab_changed(idx: int) -> void:
	_hide_tab(current_tab)
	current_tab = idx
	_show_tab(current_tab)
	emit_signal("tab_changed", current_tab)


func _show_tab(idx: int) -> void:
	tabs.get_child(idx).select()
	panels.get_child(idx).show()


func _hide_tab(idx: int) -> void:
	tabs.get_child(idx).deselect()
	panels.get_child(idx).hide()
