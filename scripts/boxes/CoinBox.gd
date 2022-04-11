# Extends the BaseBox to let the player collect coins by bouncing.
extends BaseBox

onready var particle_emitter = $CoinEmitter
onready var audio_coin = $CoinStream

func _ready():
	pass

func on_bounce(_body: KinematicBody2D):
	.on_bounce(_body)
	particle_emitter.restart()
	particle_emitter.emitting = true
	EventBus.emit_signal("coin_collected", { "value": 1, "type": "gold" })
	audio_coin.play()
