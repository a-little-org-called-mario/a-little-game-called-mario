extends Timer

const CLOUD = preload("cloud.tscn")

func _ready():
	randomize()

func _on_env_spawner_timeout():
	var cloud = CLOUD.instance()
	get_parent().add_child(cloud)
	cloud.position.x = 1200
	cloud.position.y = rand_range(50, 550)
	var scale = rand_range(1.0, 4.0)
	cloud.scale = Vector2(scale, scale)
	cloud.SPEED = -rand_range(50.0, 220.0)
	self.wait_time = rand_range(0.2, 4.0)
