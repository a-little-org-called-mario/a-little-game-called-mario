# Spawns text enemies and animates them being shot
extends TileMap

export var enemy_scene: PackedScene
export var fireball_scene: PackedScene

onready var _contributors: Contributors = preload("res://scenes/title/Contributors.gd").new()
onready var _player: Node2D = $TypeShootPlayer
onready var _spawn_timer: Timer = $SpawnTimer
onready var _spawn_location: PathFollow2D = $SpawnPath/SpawnFollow
onready var _coin_handle: CoinInventoryHandle = $CoinInventoryHandle

var _lines: Array
var _line_index: int
var _enemies: Array = []
var _pause_action: InputEventKey

func _ready() -> void:
	randomize()

	_lines = _contributors.get_lines_randomized()

	_spawn_timer.connect("timeout", self, "_spawn_enemy")
	_spawn_enemy()

	EventBus.connect("heart_changed", self, "_on_heart_change")
	_remove_pause_action()


func _exit_tree() -> void:
	_restore_pause_action()
	

func _spawn_enemy() -> void:
	var enemy = enemy_scene.instance()
	add_child(enemy)

	_spawn_location.offset = randi()
	enemy.global_position = _spawn_location.global_position
	enemy.set_target(_player)
	enemy.set_text(_lines[_line_index])
	enemy.connect("typed_out", self, "_on_enemy_typed_out")
	enemy.connect("tree_exited", self, "_on_enemy_exited", [enemy])
	_enemies.push_back(enemy)

	# use next contributor
	_line_index = _line_index + 1
	if _line_index >= 3:
		_line_index = 0
		_lines = _contributors.get_lines_randomized()

	# decrease spawn timer to make it more difficult
	_spawn_timer.wait_time = clamp(_spawn_timer.wait_time - 0.2, 0.5, 99)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		for enemy in _enemies:
			enemy.handle_input(char(event.unicode).to_upper())
		get_tree().set_input_as_handled()


func _on_heart_change(_delta: int, total: int) -> void:
	if total <= 0:
		HeartInventoryHandle.change_hearts_on(_player, 3)
		EventBus.emit_signal("level_exited")


func _on_enemy_typed_out(enemy: TypeShootEnemy) -> void:
	var fireball = fireball_scene.instance()
	add_child(fireball)

	fireball.global_position = _player.global_position
	fireball.start_moving(enemy.global_position - _player.global_position)
	
	# if the projectile doesn't hit, make sure enemy still dies
	get_tree().create_timer(2).connect("timeout", enemy, "queue_free")

	yield(enemy, "tree_exited")
	_coin_handle.change_coins(1)


func _on_enemy_exited(enemy: TypeShootEnemy) -> void:
	_enemies.remove(_enemies.find(enemy))


func _remove_pause_action():
	# a hack - we need the 'P' key for the game mode
	var actions = InputMap.get_action_list("pause")
	for action in actions:
		if action is InputEventKey and action.physical_scancode == KEY_P:
			_pause_action = action
			InputMap.action_erase_event("pause", action)


func _restore_pause_action() -> void:
	InputMap.action_add_event("pause", _pause_action)
