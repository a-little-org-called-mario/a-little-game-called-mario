# hold player information across scenes
# has to be reset on game restart
extends Resource

#NOTE: The reset function is called in the TitleMenuButton script when the button is pressed
#While the konami code hasn't been entered.
export var coins: int
export var hearts: int
export var has_flower: bool
export var has_bus: bool
export var stars: Dictionary

func reset() -> void:
	coins = 0 if !CheatsInfo.enabled_cheats.has("100Coins") else 100
	hearts = 3 if !CheatsInfo.enabled_cheats.has("30Lives") else 30
	has_flower = false
	has_bus = false
	stars = {}
