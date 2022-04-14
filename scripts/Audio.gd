extends Node


func _ready():
	EventBus.connect("volume_changed", self, "_on_volume_change")


func _on_volume_change(bus: String) -> void:
	match str(bus):
		"game":
			AudioServer.set_bus_volume_db(
				AudioServer.get_bus_index("Master"), linear2db(Settings.volume_game / 10.0)
			)
		"music":
			AudioServer.set_bus_volume_db(
				AudioServer.get_bus_index("music"), linear2db(Settings.volume_music / 10.0)
			)
		"sfx":
			AudioServer.set_bus_volume_db(
				AudioServer.get_bus_index("sfx"), linear2db(Settings.volume_sfx / 10.0)
			)
