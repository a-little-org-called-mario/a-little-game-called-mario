extends CPUParticles2D


export var running_amount: int = 6
export var crouch_amount: int = 2


const EMISSION_THRESHOLD: float = 50.0


onready var player: Player = owner


func _process(_delta: float) -> void:
	emitting = player._is_on_floor() && player.x_motion.get_motion().length_squared() > EMISSION_THRESHOLD


func reset() -> void:
	emitting = false
	restart()


func _on_Player_crouched():
	self.amount = crouch_amount


func _on_Player_uncrouched():
	self.amount = running_amount
