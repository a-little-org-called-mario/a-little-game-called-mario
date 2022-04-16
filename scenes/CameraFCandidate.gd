extends Node

func _ready() -> void:
	EventBus.emit_signal("cameraF_candidate_spawned")
	
# If I enter the tree I can get followed by camera
func _enter_tree() -> void:
	get_parent().add_to_group("CameraFCandidates")
	pass 

# If I exit the tree I can no longer get followed by camera
func _exit_tree() -> void:
	get_parent().remove_from_group("CameraFCandidates")
	pass
