extends Area2D

export(String) var starname: String
onready var audio_coin = $CoinStream

func _ready():
	self.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(_body):
	# check if body is player
	if _body is Player:
		if _body.inventory.stars.has(starname):
			call_deferred("collect_again")
		else:
			call_deferred("collect")

func collect():
	EventBus.emit_signal("star_collected", { "name": starname })
	audio_coin.play()
	monitoring = false
	yield(audio_coin, "finished")
	queue_free()

func collect_again():
	EventBus.emit_signal("star_collected_again", { "name": starname })
	audio_coin.play()
	monitoring = false
	yield(audio_coin, "finished")
	queue_free()
