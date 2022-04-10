extends Area2D

onready var audio_meow = $MeowStream
onready var audio_coin = $CoinStream
onready var animation = $Sprite/AnimationPlayer

onready var coin_counter = preload("res://scripts/CoinCounter.tres")


func _ready():
	self.connect("body_entered", self, "_on_body_entered")


func _on_body_entered(_body):
	call_deferred("collect")


func collect():
	coin_counter.add_coins(1)
	audio_meow.play()
	audio_coin.play()
	animation.play("Collect")
	monitoring = false
	yield(animation, "animation_finished")
	queue_free()
