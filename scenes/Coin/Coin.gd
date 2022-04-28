extends Area2D

onready var audio_meow = $MeowStream
onready var audio_coin = $CoinStream
onready var animation = $Sprite/AnimationPlayer

signal collected

func _ready() -> void:
	self.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node2D) -> void:
	call_deferred("collect", body)

func collect(body: Node2D) -> void:
	if CoinInventoryHandle.change_coins_on(body, 1):
		audio_meow.play()
		audio_coin.play()
		animation.play("Collect")
		monitoring = false
		yield(animation, "animation_finished")
		emit_signal("collected")
		queue_free()
