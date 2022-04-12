extends RigidBody2D
class_name PopcornKernel

const initial_scatter_force: float = 600.0
const initial_scatter_torque: float = 600.0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var pop_wait_duration: float
var pop_timer: float = 0.0

export(PackedScene) var popcorn_popped: PackedScene = preload("res://scenes/PopcornPopped.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	
	pop_wait_duration = rng.randf_range(1.5, 2.5)

	var force_direction: Vector2 = Vector2.ZERO

	rng.randomize()
	force_direction.x = rng.randf_range(-1, 1)
	rng.randomize()
	force_direction.y = rng.randf_range(-1, 1)
	
	force_direction = force_direction.normalized()
	apply_central_impulse(force_direction * initial_scatter_force)

	rng.randomize()
	apply_torque_impulse(rng.randf_range(-1, 1) * initial_scatter_torque)


func _process(delta) -> void:
	pop_timer += delta
	if pop_timer >= pop_wait_duration:
		pop()


# me when the popcorn pop í ½í²€:skull:
func pop() -> void:
	var popped = popcorn_popped.instance()
	get_parent().add_child(popped)
	popped.position = global_position
	popped.rotation = global_rotation

	queue_free()
