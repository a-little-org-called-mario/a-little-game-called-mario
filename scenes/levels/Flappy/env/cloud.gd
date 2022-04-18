extends Sprite

export var SPEED = -200

func _physics_process(delta: float) -> void:
	position.x += SPEED * delta
	if global_position.x < -100:
		queue_free()


func _on_Area2D_body_entered(_body):
	$EnterAudio.play()


func _on_Area2D_body_exited(_body):
	$ExitAudio.play()
