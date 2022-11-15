extends Node

# Playback action that can be executed on an audio player
enum PlaybackAction { PLAY, STOP, PAUSE, UNPAUSE }


func _ready():
	# Connect to signals
	EventBus.connect("level_started", self, "_on_level_started")
	EventBus.connect("level_completed", self, "_on_level_completed")
	EventBus.connect("change_scene", self, "_on_change_scene")
	EventBus.connect("volume_changed", self, "_on_volume_change")

	# Apply initial volume settings
	for bus in ["Master", "music", "sfx", "voice"]:
		_on_volume_change(bus)


# Execute a given PlaybackAction on all children of class AudioStreamPlayer
func _execute_playback_action_on_children(playback_action: int):
	for child in get_children():
		if is_instance_valid(child) and child.is_class("AudioStreamPlayer"):
			match playback_action:
				PlaybackAction.PLAY:
					child.play()
				PlaybackAction.STOP:
					child.stop()
				PlaybackAction.PAUSE:
					child.set_stream_paused(true)
				PlaybackAction.UNPAUSE:
					child.set_stream_paused(false)


# ----------------


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


func _on_change_scene(data):
	_execute_playback_action_on_children(PlaybackAction.STOP)


func _on_level_completed(data):
	_execute_playback_action_on_children(PlaybackAction.PAUSE)


func _on_level_started(data):
	_execute_playback_action_on_children(PlaybackAction.UNPAUSE)
