tool
extends Node2D

onready var anim = $AnimationPlayer
onready var beat = $BeatPlayer
var pose setget set_pose
export(int) var BPM = 360
var bpm_delay = 0

func _process(_delta):
	if Engine.editor_hint:
		return
	bpm_delay += 1
	if BPM <= bpm_delay:
		play_beat()

func set_pose(new_pose):
	pose = new_pose
	anim.play("RESET")
	anim.seek(1, true)
	anim.play(new_pose)

func play_beat():
	beat.play("Beat")
	bpm_delay = 0
