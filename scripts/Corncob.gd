extends Area2D
class_name Corncob

const num_kernels = 10
export(PackedScene) var popcorn_kernel: PackedScene = preload("res://scenes/PopcornKernel.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	pass  # Replace with function body.


func create_kernel():
	var kernel = popcorn_kernel.instance()
	get_parent().add_child(kernel)
	kernel.position = global_position


func _on_body_entered(body):
	if not body is Player:
		return

	for _i in range(num_kernels):
		call_deferred("create_kernel")
	queue_free()
