extends Area2D

export (PackedScene) var car_player

func _ready():
	connect("body_entered", self, "_body_entered")

func _body_entered(body):
	if body.is_in_group("Player"):
		body.queue_free()
		var player= car_player.instance()
		player.position= position
		get_parent().call_deferred("add_child", player)
		queue_free()
