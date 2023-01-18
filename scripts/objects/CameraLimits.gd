tool 

extends Node


export var topLeft = Vector2(0, 0)
export var bottomRight = Vector2(1024, 600)
export var limitID = 0
export var doLimitsReset = true

var topRight = Vector2(1024, 0)
var bottomLeft = Vector2(0, 600)
var currentID = 0

onready var camera_reference: Camera2D  = null


func _ready() -> void:
	if not Engine.editor_hint:
		_find_current_camera()
		if limitID == 0:
			change_limits()
		camera_reference.connect("tree_exiting", self, "_on_camera_exit_tree")


func _enter_tree() -> void:
	EventBus.connect("cameraL_enter_set_area",self,"_on_enter_set_area")


func _on_camera_exit_tree() -> void:
	EventBus.disconnect("cameraL_enter_set_area",self,"_on_enter_set_area")
	if camera_reference != null and doLimitsReset:
		camera_reference.limit_left = -10000000
		camera_reference.limit_right = 10000000
		camera_reference.limit_top = -10000000
		camera_reference.limit_bottom = 10000000


func _process(_delta):
	set_corners()
	
	if Engine.editor_hint:
		reset_points()
		set_points()
		$Line2D.visible = true
		
	else:
		change_limits()
		$Line2D.visible = false


func reset_points():
	if $Line2D.get_point_count() != 5:
		$Line2D.clear_points()
		for _i in range(5):
			$Line2D.add_point(Vector2(0, 0))


func set_corners():
	topRight.x = bottomRight.x
	topRight.y = topLeft.y
	bottomLeft.x = topLeft.x
	bottomLeft.y = bottomRight.y


func set_points():
	$Line2D.set_point_position(0, topLeft)
	$Line2D.set_point_position(1, topRight)
	$Line2D.set_point_position(2, bottomRight)
	$Line2D.set_point_position(3, bottomLeft)
	$Line2D.set_point_position(4, topLeft)


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


func change_limits():
	if camera_reference != null and currentID == limitID:
		camera_reference.limit_left = topLeft.x
		camera_reference.limit_right = bottomRight.x
		camera_reference.limit_top = topLeft.y
		camera_reference.limit_bottom = bottomRight.y


func _on_enter_set_area(id):
	currentID = id

