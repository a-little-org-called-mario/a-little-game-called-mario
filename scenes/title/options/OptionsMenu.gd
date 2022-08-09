extends Control

export (NodePath) onready var game_volume = get_node(game_volume) as BaseOption
export (NodePath) onready var music_volume = get_node(music_volume) as BaseOption
export (NodePath) onready var sfx_volume = get_node(sfx_volume) as BaseOption
export (NodePath) onready var voice_volume = get_node(voice_volume) as BaseOption
export (NodePath) onready var camera_lean = get_node(camera_lean) as BaseOption
export (NodePath) onready var screen_shake = get_node(screen_shake) as BaseOption
export (NodePath) onready var crt_filter = get_node(crt_filter) as BaseOption


func _ready() -> void:
	game_volume.value = Settings.volume_game
	music_volume.value = Settings.volume_music
	sfx_volume.value = Settings.volume_sfx
	voice_volume.value = Settings.volume_voice
	
	camera_lean.value = Settings.camera_lean
	screen_shake.value = Settings.screen_shake
	crt_filter.value = Settings.crt_filter


func _on_GameVolume_value_changed(value) -> void:
	Settings.volume_game = value
	EventBus.emit_signal("volume_changed", "Master")


func _on_MusicVolume_value_changed(value) -> void:
	Settings.volume_music = value
	EventBus.emit_signal("volume_changed", "music")


func _on_SFXVolume_value_changed(value) -> void:
	if (value != Settings.volume_sfx):
		$Audio/SFX.play()
	Settings.volume_sfx = value
	EventBus.emit_signal("volume_changed", "sfx")


func _on_VoiceVolume_value_changed(value) -> void:
	if (value != Settings.volume_voice):
		$Audio/Voice.play()
	Settings.volume_voice = value
	EventBus.emit_signal("volume_changed", "voice")


func _on_CameraLean_value_changed(value):
	Settings.camera_lean = value


func _on_ScreenShake_value_changed(value):
	Settings.screen_shake = value


func _on_CRTFilter_value_changed(value):
	Settings.crt_filter = value
	EventBus.emit_signal("crt_filter_toggle", Settings.crt_filter)


func _on_BackMenuButton_pressed() -> void:
	Settings.save_data()
