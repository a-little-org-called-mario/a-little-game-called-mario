extends TileMap


var killed_enemy_count = 0
onready var total_enemy_count = get_tree().get_nodes_in_group("enemy").size()


func _ready():
	_connect_missing_dead_enemy_signals()


func _connect_missing_dead_enemy_signals():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not enemy.has_signal("dead"):
			continue
		if enemy.is_connected("dead", self, "_on_enemy_dead"):
			continue
		enemy.connect("dead", self, "_on_enemy_dead")


func _on_enemy_dead(killer):
	killed_enemy_count += 1
	if total_enemy_count <= killed_enemy_count:
		$EndPortal.show()


func _on_PortalTimer_timeout():
	$EndPortal.show()
