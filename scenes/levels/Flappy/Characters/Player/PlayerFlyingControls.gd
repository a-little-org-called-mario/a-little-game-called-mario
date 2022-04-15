extends RigidBody2D
class_name PlayerFlying

const ASCEND_FORCE = -200
const MAX_ROTATION_UP = -30.0
const MAX_ROTATION_DOWN = 90.0

func _ready():
	EventBus.connect("heart_changed", self, "_on_heart_change")


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		linear_velocity.y = ASCEND_FORCE;
		angular_velocity = -10.0

	if rotation_degrees <= MAX_ROTATION_UP:
		angular_velocity = 0
		rotation_degrees = MAX_ROTATION_UP
		
	if linear_velocity.y > 0:
		if rotation_degrees <= MAX_ROTATION_DOWN:
			angular_velocity = 5
		else:
			angular_velocity = 0

func crash() -> void:
	EventBus.emit_signal("heart_changed", {"value": -1})
	
func gameOver() -> void:
	get_tree().reload_current_scene()

func _on_heart_change(_data):
	var value = get_node("../UI/UI/HeartCount").count
	#one because this is checked before the hearts counter is actually reduced
	if value <= 1:
		gameOver()
