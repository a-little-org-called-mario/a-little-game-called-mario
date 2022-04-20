extends TileMap

func _on_WallMech_dead(killer):
	$EndPortal.show()
