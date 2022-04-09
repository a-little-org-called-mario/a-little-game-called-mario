# Extends the BaseBox to let the player collect coins by bouncing.
extends "res://scripts/boxes/BaseBox.gd"

onready var particle_emitter = $CoinEmitter

func _ready():
	pass

func on_bounce():
	.on_bounce()
	particle_emitter.restart()
	particle_emitter.emitting = true
	EventBus.emit_signal("coin_collected", { "value": 1, "type": "gold" })
