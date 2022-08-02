extends Timer

const PIPES = preload("Pipes.tscn")


func _ready():
	randomize()

func _on_Timer_timeout():
	var pipes = PIPES.instance()
	get_parent().add_child(pipes)
	pipes.position.x = 1200
	pipes.position.y = rand_range(240, 360)
	pipes.z_index = 1
