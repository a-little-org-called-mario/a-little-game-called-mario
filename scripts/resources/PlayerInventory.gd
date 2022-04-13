# hold player information across scenes
# has to be reset on game restart
extends Resource

export var coins: int

func _init() -> void:
	reset()

func reset() -> void:
    coins = 0
