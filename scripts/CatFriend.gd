# Follows Mario around
extends Enemy

const OFFSET = Vector2(-24, -32)
const MAX_SPEED = 220

var _player: Player
var _targetPos: Vector2

var _target_node: Node2D
var _cat_manager: CatManager


func _ready():
	EventBus.connect("hub_entered", self, "_on_hub_entered")


func _on_hub_entered():  #Properly remove cats when entering a level from the hub
	queue_free()


func set_player(player: Player):
	_player = player

	_cat_manager = _player.get_node_or_null("CatManager")
	if not _cat_manager:
		var manager := preload("res://scenes/platformer/characters/player_components/CatManager.tscn").instance()
		_player.add_child(manager, true)
		_cat_manager = manager
		assert(player.get_node("CatManager") == manager)

	_target_node = _cat_manager.add_cat(self)


func ai(_delta: float):
	if is_instance_valid(_player) and _player.is_inside_tree():
		_targetPos = _target_node.global_position + OFFSET


func move(_delta: float):
	var dir = _targetPos - global_position
	if dir.length_squared() < MAX_SPEED:
		return

	move_and_slide(dir.normalized() * MAX_SPEED, Vector2.UP)
