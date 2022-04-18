extends RigidBody2D
class_name PopcornPopped

const pop_force = 100
var rng = RandomNumberGenerator.new()
onready var particles = $Particles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("body_entered", self, "_on_body_entered")

	var force_direction = Vector2(0, 0)

	rng.randomize()
	force_direction.x = rng.randf_range(-1, 1)
	force_direction.y = -1

	force_direction = force_direction.normalized()
	apply_central_impulse(force_direction * pop_force)

	particles.emitting = true


func _on_body_entered(body) -> void:
	if not body is Player:
		return
	call_deferred("collect", body)


func collect(body) -> void:
	CoinInventoryHandle.change_coins_on(body, 1)
	HeartInventoryHandle.change_hearts_on(body, 1)
	queue_free()
