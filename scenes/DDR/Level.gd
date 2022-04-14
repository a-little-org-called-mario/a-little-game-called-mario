extends Node2D

export var next_level: PackedScene

onready var music = $Music
export(int) var TimeMultiplier = 1000
export(float) var seekSeconds = 0

func _ready():
	music.play(seekSeconds)

func _process(_delta):
	var time = music.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	time *= TimeMultiplier
	emit_signal("set_tick", time)

func _on_Music_finished():
	EventBus.emit_signal("level_completed", {})

signal set_tick
