extends Control

export(int) var level = 1
export(String) var level_url = "res://scenes/sokoban/levels/01.tscn"


func _ready():
	$Button.text = str(level)


func _on_Button_pressed():
	EventBus.emit_signal("change_scene", {"scene": level_url})
