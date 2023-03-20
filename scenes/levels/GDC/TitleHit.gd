extends RigidBody2D

export (NodePath) var actualTitle


func _on_RigidBody2D_body_entered(body:Node):
	if body is Player:
		hide()
		get_node(actualTitle).show()
