extends Control

## Toasty.gd

# An homage to Mortal Kombat.
#
# Upon collecting X coins in Y seconds, Waluigi appears in the bottom right
# corner of the screen and an audio clip plays saying "toasty" in a high-
# pitched voice.
#
# In Mortal Kombat, if you pressed Down and Start while the "toasty guy" was on
# the screen, you would be transported to a secret level.
#
# As of now, this toasty guy doesn't have that feature.
#
# To avoid constant or repeated triggers, there's a five minute cooldown timer,
# the Cooldown node.


export var target_coin_streak : int = 10

var can_toasty : bool = true
var coins_collected_streak : int = 0

#func _init() -> void:
#	pass


func _ready() -> void:
	EventBus.connect("coin_collected", self, "_on_coin_collected")


func trigger_toasty() -> void:
	can_toasty = false
	$Cooldown.start()
	$AnimationPlayer.play('toasty')


func _on_coin_collected(_data) -> void:
	# Return early if it's too soon to toasty again:
	if not can_toasty:
		return
	
	$CoinTimer.start()
	
	coins_collected_streak += 1
	
	if coins_collected_streak >= target_coin_streak:
		trigger_toasty()


func _on_Cooldown_timeout() -> void:
	coins_collected_streak = 0


func _on_CoinTimer_timeout() -> void:
	coins_collected_streak = 0
