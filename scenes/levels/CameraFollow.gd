extends Position2D
onready var camera_reference: Camera2D  = get_tree().get_nodes_in_group("Camera")[0]
onready var follow_candidates: Array = get_tree().get_nodes_in_group("CameraFCandidates")
export var follow_horizontally: bool = true
export var follow_vertically: bool = false
export(float,0,1) var follow_speed: float = 0.1
var follow_index: int = 0

func _enter_tree() -> void:
	EventBus.connect("cameraF_candidate_spawned",self,"_get_follow_candidates")
	EventBus.connect("cameraF_change_candidate",self,"_next_candidate")

func _exit_tree() -> void:
	EventBus.disconnect("cameraF_candidate_spawned",self,"_get_follow_candidates")
	EventBus.disconnect("cameraF_change_candidate",self,"_next_candidate")
	
func _get_follow_candidates() -> void:
	follow_candidates = get_tree().get_nodes_in_group("CameraFCandidates")

func _process(_delta: float) -> void:

	if camera_reference and follow_candidates.size()>0 :
		if follow_horizontally:
			camera_reference.position.x = lerp(camera_reference.position.x, follow_candidates[follow_index].position.x, follow_speed)
		if follow_vertically:
			camera_reference.position.y = lerp(camera_reference.position.y, follow_candidates[follow_index].position.y, follow_speed)

func _next_candidate(val : int = 1) -> void:
	_get_follow_candidates()
	follow_index = (follow_index + val) % follow_candidates.size()
