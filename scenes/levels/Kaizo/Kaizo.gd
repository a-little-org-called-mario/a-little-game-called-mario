extends TileMap


func _ready():
	EventBus.emit_signal("bgm_changed", get_node("AudioStreamPlayer"))


func _exit_tree():
	EventBus.emit_signal("bgm_changed", "reset")

