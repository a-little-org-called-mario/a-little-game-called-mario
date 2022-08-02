extends Sprite

export var SPEED = -200
export(bool) var player_can_enter_exit_cloud: bool = false

func _physics_process(delta: float) -> void:
	position.x += SPEED * delta
	if global_position.x < -100:
		queue_free()


func _on_Area2D_body_entered(_body):
	if player_can_enter_exit_cloud:
		$EnterAudio.play()


func _on_Area2D_body_exited(_body):
	if player_can_enter_exit_cloud:
		$ExitAudio.play()
