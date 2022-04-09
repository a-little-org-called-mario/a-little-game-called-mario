tool
extends Panel

signal tree_built # used for debugging

const Todo := preload("res://addons/Todo_Manager/todo_class.gd")
const TodoItem := preload("res://addons/Todo_Manager/todoItem_class.gd")

var sort_alphabetical := true

onready var tree := $Tree as Tree

func build_tree(todo_item : TodoItem, patterns : Array) -> void:
	tree.clear()
	var root := tree.create_item()
	root.set_text(0, "Scripts")
	var script := tree.create_item(root)
	script.set_text(0, todo_item.get_short_path() + " -------")
	script.set_metadata(0, todo_item)
	for todo in todo_item.todos:
		var item := tree.create_item(script)
		var content_header : String = todo.content
		if "\n" in todo.content:
			content_header = content_header.split("\n")[0] + "..."
		item.set_text(0, "(%0) - %1".format([todo.line_number, content_header], "%_"))
		item.set_tooltip(0, todo.content)
		item.set_metadata(0, todo)
		for pattern in patterns:
			if pattern[0] == todo.pattern:
				item.set_custom_color(0, pattern[1])
	emit_signal("tree_built")


func sort_alphabetical(a, b) -> bool:
	if a.script_path > b.script_path:
		return true
	else:
		return false

func sort_backwards(a, b) -> bool:
	if a.script_path < b.script_path:
		return true
	else:
		return false

