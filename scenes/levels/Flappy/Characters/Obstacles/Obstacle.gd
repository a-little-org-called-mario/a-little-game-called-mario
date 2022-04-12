extends Node2D

const SPEED = -200

func _physics_process(delta: float) -> void:
	position.x += SPEED * delta
	if global_position.x < -100:
		queue_free()


func _on_pipe_body_entered(body):
	if body is PlayerFlying:
		if body.has_method("crash"):
			body.crash()
