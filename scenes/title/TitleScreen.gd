extends Control

func _ready():
	Settings.load_data()
	var audiogame : AudioStreamPlayer = get_node_or_null("AudioTitle")
	if audiogame:
		audiogame.playing = true
