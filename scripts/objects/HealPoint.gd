extends Area2D

func _body_entered(body):
	HeartInventoryHandle.change_hearts_on(body, 99)
