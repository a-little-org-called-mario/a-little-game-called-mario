# Extends the BaseBox to let the player collect coins by bouncing.
extends BaseBox

onready var particle_emitter = $CoinEmitter
onready var audio_coin = $CoinStream

func on_bounce(body: KinematicBody2D) -> void:
	if CoinInventoryHandle.change_coins_on(body, 1):
		.on_bounce(body)
		particle_emitter.restart()
		particle_emitter.emitting = true
		audio_coin.play()
