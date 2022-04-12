# Follows Mario around
extends Enemy

const OFFSET: Vector2 = Vector2(-24, -32)
const MAX_SPEED: float = 220.0

var _player: Player
var _targetPos: Vector2


func set_player(player: Player) -> void:
	_player = player


func ai(_delta: float) -> void:
	_targetPos = _player.global_position + OFFSET


func move(_delta: float) -> void:
	var dir = _targetPos - global_position
	if dir.length_squared() < MAX_SPEED:
		return

	move_and_slide(dir.normalized() * MAX_SPEED, Vector2.UP)
