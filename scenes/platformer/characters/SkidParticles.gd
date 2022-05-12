extends CPUParticles2D

onready var player: Player = owner


func _process(_delta: float) -> void:
	emitting = player.skidding


func reset() -> void:
	emitting = false
	restart()
