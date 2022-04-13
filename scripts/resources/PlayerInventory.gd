# hold player information across scenes
# has to be reset on game restart
extends Resource

export var coins: int
export var hearts: int
export var has_flower: bool
export var has_bus: bool

func reset() -> void:
	coins = 0
	hearts = 3
	has_flower = false
	has_bus = false
