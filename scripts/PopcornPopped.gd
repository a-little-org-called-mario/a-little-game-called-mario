extends RigidBody2D
class_name PopcornPopped

const pop_force: int = 100

onready var audio_coin: AudioStreamPlayer = $CoinStream
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("body_entered", self, "_on_body_entered")
	
	var force_direction: Vector2 = Vector2.ZERO
	
	rng.randomize()
	force_direction.x = rng.randf_range(-1,1)
	force_direction.y = -1
	
	force_direction = force_direction.normalized()
	apply_central_impulse(force_direction * pop_force)


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	call_deferred("collect")
	
func collect() -> void:
	EventBus.emit_signal("coin_collected", { "value": 1, "type": "corn" })
	queue_free()
