tool

extends Area2D

# can be 1, 2, 3, 5, 8, 10, 20, 50, or 74
export var value = 1

onready var audio_meow = $MeowStream
onready var audio_coin = $CoinStream
onready var animation = $Sprite/AnimationPlayer
onready var sprite = $Sprite

signal collected

func _ready() -> void:
	self.connect("body_entered", self, "_on_body_entered")


func _process(delta):
	sprite.animation = "value" + str(value)


func _on_body_entered(body: Node2D) -> void:
	call_deferred("collect", body)

func collect(body: Node2D) -> void:
	for i in range(value):
		if CoinInventoryHandle.change_coins_on(body, 1) and i == (value-1):
			audio_meow.play()
			audio_coin.play()
			animation.play("Collect")
			monitoring = false
			yield(animation, "animation_finished")
			emit_signal("collected")
			queue_free()
