# Spawns text enemies and animates them being shot
extends TileMap

export var enemy_scene: PackedScene
export var fireball_scene: PackedScene

onready var _inventory = preload("res://scripts/resources/PlayerInventory.tres")
onready var _contributors: Contributors = preload("res://scenes/title/Contributors.gd").new()
onready var _player: Node2D = $TypeShootPlayer
onready var _spawn_timer: Timer = $SpawnTimer
onready var _spawn_location: PathFollow2D = $SpawnPath/SpawnFollow
onready var _coin_handle: CoinInventoryHandle = $CoinInventoryHandle

var _lines: Array
var _line_index: int

func _ready() -> void:
	randomize()

	_lines = _contributors.get_lines_randomized()

	_spawn_timer.connect("timeout", self, "_spawn_enemy")
	_spawn_enemy()

	EventBus.connect("heart_changed", self, "_on_heart_change")

	
func _spawn_enemy() -> void:
	var enemy = enemy_scene.instance()
	add_child(enemy)

	_spawn_location.offset = randi()
	enemy.global_position = _spawn_location.global_position
	enemy.set_target(_player)
	enemy.set_text(_lines[_line_index])
	_line_index = (_line_index + 1) % _lines.size()
	enemy.connect("typed_out", self, "_on_enemy_typed_out")
	_spawn_timer.wait_time = clamp(_spawn_timer.wait_time - 0.2, 0.5, 99)


func _on_heart_change(data: Dictionary) -> void:
	if not data.has("value"):
		return

	_inventory.hearts += data.value
	if _inventory.hearts <= 0:
		get_tree().reload_current_scene()


func _on_enemy_typed_out(enemy: TypeShootEnemy) -> void:
	var fireball = fireball_scene.instance()
	add_child(fireball)

	fireball.global_position = _player.global_position
	fireball.start_moving(enemy.global_position - _player.global_position)
	
	# if the projectile doesn't hit, make sure enemy still dies
	get_tree().create_timer(2).connect("timeout", enemy, "queue_free")

	yield(enemy, "tree_exited")
	_coin_handle.change_coins(1)
