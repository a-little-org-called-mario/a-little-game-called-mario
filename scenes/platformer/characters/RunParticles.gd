extends CPUParticles2D


const EMISSION_THRESHOLD: float = 50.0

onready var player: Player = owner


func _process(_delta: float) -> void:
	emitting = player._is_on_floor() && player.x_motion.get_motion().length_squared() > EMISSION_THRESHOLD


func reset() -> void:
	emitting = false
	restart()

