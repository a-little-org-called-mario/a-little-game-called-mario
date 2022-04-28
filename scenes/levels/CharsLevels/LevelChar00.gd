extends TileMap


var killed_enemy_count = 0
onready var total_enemy_count = get_tree().get_nodes_in_group("enemy").size()


func _on_enemy_dead(killer):
	killed_enemy_count += 1
	if total_enemy_count <= killed_enemy_count:
		$EndPortal.show()


func _on_PortalTimer_timeout():
	$EndPortal.show()
