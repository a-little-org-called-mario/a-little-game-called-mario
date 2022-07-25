extends Control

onready var game_container: HBoxContainer = $CustomTabContainer/Panel/AudioSettings/GameContainer
onready var music_container: HBoxContainer = $CustomTabContainer/Panel/AudioSettings/MusicContainer
onready var sfx_container: HBoxContainer = $CustomTabContainer/Panel/AudioSettings/SFXContainer
onready var voice_container: HBoxContainer = $CustomTabContainer/Panel/AudioSettings/VoiceContainer

func _ready() -> void:
	game_container.set_value(Settings.volume_game)
	music_container.set_value(Settings.volume_music)
	sfx_container.set_value(Settings.volume_sfx)
	voice_container.set_value(Settings.volume_voice)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"): # save settings on esc
		Settings.save_data()


func _on_GameContainer_value_changed(value) -> void:
	Settings.volume_game = value
	EventBus.emit_signal("volume_changed", "Master")

func _on_MusicContainer_value_changed(value) -> void:
	Settings.volume_music = value
	EventBus.emit_signal("volume_changed", "music")
	
func _on_SFXContainer_value_changed(value) -> void:
	Settings.volume_sfx = value
	EventBus.emit_signal("volume_changed", "sfx")

func _on_VoiceContainer_value_changed(value) -> void:
	Settings.volume_voice = value
	EventBus.emit_signal("volume_changed", "voice")

func _on_BackMenuButton_pressed() -> void:
	Settings.save_data()

