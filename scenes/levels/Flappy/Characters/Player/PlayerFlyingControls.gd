extends RigidBody2D
class_name PlayerFlying

signal game_over

const ASCEND_FORCE = -200
const MAX_ROTATION_UP = -30.0
const MAX_ROTATION_DOWN = 90.0

var died = false

onready var _heart_handle = $HeartInventoryHandle

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("heart_changed", self, "_on_heart_change")


func _physics_process(_delta: float) -> void:
	if !died && Input.is_action_just_pressed("jump"):
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
	_heart_handle.change_hearts(-1)
	$CrashAudio.play()
	
func _on_heart_change(_delta: int, total: int) -> void:
	if total <= 0:
		gameOver()
		_heart_handle.call_deferred("change_hearts", 3)

func gameOver() -> void:
	died = true
	emit_signal("game_over")
