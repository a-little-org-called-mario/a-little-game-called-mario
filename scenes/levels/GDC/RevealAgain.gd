extends Area2D


export (NodePath) var show_thing
export (NodePath) var show_thing2


func _on_Area2D_body_entered(body:Node):
	if body is Player:
		if get_parent().pressed:
			$Drumroll.play()
		elif not get_node("MaintenanceHatch/CollisionShape2D").disabled:
			yield(get_tree().create_timer(1), "timeout")
			get_node("MaintenanceHatch/CollisionShape2D").disabled = false


func _on_Drumroll_finished():
	$Crash.play()
	get_node(show_thing).show()
	get_node(show_thing2).show()


func _on_Keyboard_finished():
	get_node("MaintenanceHatch/CollisionShape2D").disabled = true
	get_node("MaintenanceHatch").queue_free()
