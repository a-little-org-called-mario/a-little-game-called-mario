extends Node


func _ready():
	EventBus.connect("volume_changed", self, "_on_volume_change")
	for bus in ["Master", "music", "sfx", "voice"]:
		_on_volume_change(bus)


func _on_volume_change(bus: String):
	var volume: int = 0
	match bus:
		"Master":
			volume = Settings.volume_game
		"music":
			volume = Settings.volume_music
		"sfx":
			volume = Settings.volume_sfx
		"voice":
			volume = Settings.volume_voice
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear2db(volume / 10.0))
