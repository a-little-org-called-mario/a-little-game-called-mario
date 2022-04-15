# Holds the player's persistent stats across scenes.
# You should call reset on game load or when starting a new game
extends Resource

export var max_hearts : int
export var jump_xp : int
export var coin_shoot_xp : int
export var intelligence : int
export var speed : int
export var charisma : int
export var swim : int
export var acrobatics : int
export var building : int
export var sanity : int

# Resets stats to default
func reset() -> void:
	max_hearts = 3
	jump_xp = 0
	coin_shoot_xp = 0
	intelligence = 1
	speed = 1
	charisma = 1
	swim = 1
	acrobatics = 1
	building = 1
	sanity = 10
