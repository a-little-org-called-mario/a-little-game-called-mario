# Add this Sript in a child of anything that you want the camera to be able to follow, if there is
# more than one candidate on your level use the cameraF_change_candidate(step_int) signal to change
# what is the camera following

extends Node


# If I enter the tree I can get followed by camera
func _enter_tree() -> void:
	get_parent().add_to_group("CameraFCandidates")
	EventBus.emit_signal("cameraF_candidate_spawned")


# If I exit the tree I can no longer get followed by camera
func _exit_tree() -> void:
	get_parent().remove_from_group("CameraFCandidates")
	EventBus.emit_signal("cameraF_candidate_spawned")
