extends Area2D

var inventory = preload("res://scripts/resources/PlayerInventory.tres")

export(String) var starname: String
onready var audio_coin = $CoinStream

func _ready() -> void:
	self.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node) -> void:
	# check if body is player
	if body is Player:
		call_deferred("collect", inventory.stars.has(starname) && inventory.stars[starname])

func collect(again: bool = false) -> void:
	if not again:
		inventory.stars[starname] = true
	EventBus.emit_signal("star_collected", starname, again)
	audio_coin.play()
	monitoring = false
	yield(audio_coin, "finished")
	queue_free()
