# Camera Follow tutorial
#
# * Add this script on a level where you want the camera to follow something
#
# * Add "CameraFCandidate.gd" script to a child of the thing(s) you want to follow
#
# * If there is more than one candidate on your level, use the "cameraF_change_candidate" signal,
#	that will move to the next available candidate, you can add a int in the parameter to skip candidates
#
# * If you have more than one camera on your level, you can send the "cameraF_update_current_camera" signal
# 	to change the camera to the current camera
#
# * You can stop following candidates using the external variable 'following' or using the "cameraF_set_following" signal
#	the signal receives a bool with the state you want 'following' to be
#
# * If you want to move the camera use the "cameraF_move_camera" signal, this signal receives two parameters, x and y. 
#	don't forget to make following false if you want the camera to stay there
#
# * Camera position resets when starting a new level, but if you want to reset it on the same level use "cameraF_reset_camera" 
#	this will turn false 'following' variable and return the camera to where it started

extends Position2D
onready var camera_reference: Camera2D  = null
onready var follow_candidates: Array = get_tree().get_nodes_in_group("CameraFCandidates")
export var follow_horizontally: bool = true
export var follow_vertically: bool = false
export(float,0,1) var follow_speed: float = 0.1
export var following: bool = true
var follow_index: int = 0

func _ready() -> void:
	_find_current_camera()
	# If there is no camera (probably because you are running the scene by itself)
	# create a camera and make it current. 
	if camera_reference == null:
		camera_reference = Camera2D.new()
		get_tree().root.call_deferred("add_child",camera_reference)
		camera_reference.make_current()

func _enter_tree() -> void:
	EventBus.connect("cameraF_candidate_spawned",self,"_get_follow_candidates")
	EventBus.connect("cameraF_change_candidate",self,"_next_candidate")
	EventBus.connect("cameraF_update_current_camera",self,"_find_current_camera")
	EventBus.connect("cameraF_reset_camera",self,"_reset_cam")
	EventBus.connect("cameraF_move_camera_to",self,"_move_cam_to")
	EventBus.connect("cameraF_set_following",self,"_set_following")

func _exit_tree() -> void:
	EventBus.disconnect("cameraF_candidate_spawned",self,"_get_follow_candidates")
	EventBus.disconnect("cameraF_change_candidate",self,"_next_candidate")
	EventBus.disconnect("cameraF_update_current_camera",self,"_find_current_camera")
	EventBus.disconnect("cameraF_reset_camera",self,"_reset_cam")
	EventBus.disconnect("cameraF_move_camera_to",self,"_move_cam_to")
	EventBus.disconnect("cameraF_set_following",self,"_set_following")
	
func _get_follow_candidates() -> void:
	follow_candidates = get_tree().get_nodes_in_group("CameraFCandidates")

func _get_camera_candidates() -> Array:
	return get_tree().get_nodes_in_group("Cameras")

func _find_current_camera() -> void:
	var camera_candidates = _get_camera_candidates()
	if camera_candidates.size()>0:
		for cam in camera_candidates:
			if cam.current:
				camera_reference = cam
	else:
		camera_reference = null

func _process(_delta: float) -> void:
	if following and camera_reference and follow_candidates.size() > 0:
		if follow_index >= len(follow_candidates):
			_next_candidate()
		if follow_horizontally:
			camera_reference.position.x = lerp(camera_reference.position.x, follow_candidates[follow_index].position.x, follow_speed)
		if follow_vertically:
			camera_reference.position.y = lerp(camera_reference.position.y, follow_candidates[follow_index].position.y, follow_speed)

func _next_candidate(val : int = 1) -> void:
	_get_follow_candidates()
	follow_index = (follow_index + val) % follow_candidates.size()

func _set_following(state: bool) -> void:
	following = state
	
func _move_cam_to(x: int, y: int) -> void:
	camera_reference.position.x = x
	camera_reference.position.y = y
	
func _reset_cam() -> void:
	following = false
	camera_reference.position = get_viewport_rect().size / 2
