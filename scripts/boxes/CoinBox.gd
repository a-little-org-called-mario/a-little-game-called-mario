# Extends the BaseBox to let the player collect coins by bouncing.
extends BaseBox

onready var particle_emitter: Particles2D = $CoinEmitter
onready var audio_coin: AudioStreamPlayer2D = $CoinStream

func on_bounce(body: KinematicBody2D) -> void:
	.on_bounce(body)
	particle_emitter.restart()
	particle_emitter.emitting = true
	EventBus.emit_signal("coin_collected", { "value": 1, "type": "gold" })
	audio_coin.play()
