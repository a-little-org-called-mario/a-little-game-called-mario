extends Control

export(NodePath) onready var notepad = get_node(notepad) as TextureButton


func _ready():
	EventBus.connect("notes_opened", self, "_on_notes_opened")
	EventBus.connect("notes_closed", self, "_on_notes_closed")
	EventBus.connect("notes_updated", self, "_on_notes_updated")


func _on_notes_opened() -> void:
	notepad.disabled = false
	notepad.pressed = true


func _on_notes_closed() -> void:
	notepad.disabled = false
	notepad.pressed = false


func _on_notes_updated() -> void:
	notepad.disabled = true
