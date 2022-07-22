extends Node2D

export (NodePath) var gameover_ui_nodepath

onready var gameover_ui: Control = get_node(gameover_ui_nodepath) as Control


func _ready():
	self.set_process_unhandled_input(false)


func _on_Player_game_over():
	gameover_ui.show()
	self.set_process_unhandled_input(true)


func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		EventBus.emit_signal("restart_level")
		gameover_ui.hide()
		self.set_process_unhandled_input(false)
	if event.is_action_pressed("undo"):
		EventBus.emit_signal("level_exited")
