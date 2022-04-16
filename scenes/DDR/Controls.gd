extends Node

var poses = [ "down", "up", "left", "right" ]

export(NodePath) var playerActorPath
onready var playerActor = get_node(playerActorPath)

export(NodePath) var playerTrackPath
onready var playerTrack = get_node(playerTrackPath)


func _process(_delta):
	for pose in poses:
		if Input.is_action_just_pressed(pose):
			playerActor.pose = pose
			emit_signal("player_pose_set", pose)
		elif playerActor.pose == pose and Input.is_action_just_released(pose):
			playerActor.pose = "idle"

signal player_pose_set(pose)
