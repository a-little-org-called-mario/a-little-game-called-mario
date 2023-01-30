extends RigidBody2D


export var spawn_interval : float = 0.5
export var direction_variance : float = 0.5
export var min_speed : float = 30
export var max_speed : float = 100
export var min_radius : float = 10
export var max_radius : float = 24
export var bubble_scene : PackedScene = preload("res://scenes/toys/Bubble.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.start(spawn_interval)


func _on_SpawnTimer_timeout():
	var node = bubble_scene.instance()
	node.velocity = Vector2.UP.rotated(rand_range(-1, 1) * PI * direction_variance) * rand_range(min_speed, max_speed)
	node.color = Color.from_hsv(randf(), 1, 1)
	node.radius = rand_range(min_radius, max_radius)
	node.global_position = $BubbleSpawner.global_position
	get_parent().add_child(node)
