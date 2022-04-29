extends Control

## Toasty.gd

# An homage to Mortal Kombat.
#
# Upon collecting 10 coins in 2 seconds, Gassy Randal appears in the bottom right
# corner of the screen and an audio clip plays saying "toasty" in a high-
# pitched voice.
#
# To avoid constant or repeated triggers, there's a five minute cooldown timer,
# the Cooldown node.
#
# In Mortal Kombat, if you pressed Down and Start while the "toasty guy" was on
# the screen, you would be transported to a secret level.
#
# As of now, this "toasty guy" doesn't have a secret, but there is a variable
# that controls whether or not a future secret feature can be activated.
#
# TODO: add a button combo that triggers the secret. It would probably go in an
# _input function or _process.


# The number of coins to be collected before CoinTimer runs out
export var target_coin_streak : int = 10

# While the "toasty guy" is on screen, allow a certain button combo to activate
# a secret. This value is toggled by the AnimationPlayer.
export var can_activate_secret : bool = false


# The current number of coins collected since the last time CoinTimer ran out
var coins_collected_streak : int = 0

# Whether or not the "toasty guy" can appear. On a cooldown defined by the Cooldown
# timer.
var can_toasty : bool = true


#func _init() -> void:
#	pass


func _ready() -> void:
	EventBus.connect("coin_collected", self, "_on_coin_collected")


func trigger_toasty() -> void:
	can_toasty = false
	$Cooldown.start()
	$AnimationPlayer.play('toasty')


# Use this function when you add a secret trigger following a button combo.
func activate_secret() -> void:
	if not can_activate_secret:
		return


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
