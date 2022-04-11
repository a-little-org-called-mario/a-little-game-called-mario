extends Area2D
class_name Corncob

export(int) var num_kernels: int = 10
export(PackedScene) var popcorn_kernel: PackedScene = preload("res://scenes/PopcornKernel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("body_entered", self, "_on_body_entered")
	pass # Replace with function body.



func create_kernel() -> void:
	var kernel = popcorn_kernel.instance()
	get_parent().add_child(kernel)
	kernel.position = global_position
	

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	for _i in range(num_kernels):
		create_kernel();
	queue_free()
