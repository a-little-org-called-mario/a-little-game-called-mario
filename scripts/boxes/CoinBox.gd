# Extends the BaseBox to let the player collect coins by bouncing.
extends "res://scripts/boxes/BaseBox.gd"

onready var particle_emitter = $CoinEmitter
onready var audio_meow = $MeowStream
onready var audio_coin = $CoinStream
onready var coin_counter = preload("res://scripts/CoinCounter.tres")


func _ready():
	pass


func on_bounce():
	.on_bounce()
	particle_emitter.restart()
	particle_emitter.emitting = true
	coin_counter.add_coins(1)
	audio_meow.play()
	audio_coin.play()
