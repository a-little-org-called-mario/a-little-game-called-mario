extends Node2D

onready var scoreLabel = $Score
onready var music = $Music
export(int) var TimeMultiplier = 1000
export(float) var seekSeconds = 0
var total_score = 0

func _ready():
	music.play(seekSeconds)
	EventBus.emit_signal("ui_visibility_changed", false)
	EventBus.emit_signal("bgm_changed", {"playing": false})

func _process(_delta):
	var time = music.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	time *= TimeMultiplier
	emit_signal("set_tick", time)

func _on_Music_finished():
	EventBus.emit_signal("change_scene", { "scene": "res://scenes/Main.tscn" })

func _on_note_hit(score):
	total_score += score
	scoreLabel.text = "Score: " + str(total_score)
	

signal set_tick
