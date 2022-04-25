extends StaticBody2D

export var id: String

onready var _raycast: RayCast2D = $Ray


func _physics_process(_delta: float) -> void:
	if _raycast.is_colliding():
		press()


func press() -> void:
	set_physics_process(false)
	$AnimationPlayer.play("Press")


func actual_press() -> void:
	EventBus.emit_signal("small_screen_shake")
	EventBus.emit_signal("big_button_pressed", id)
