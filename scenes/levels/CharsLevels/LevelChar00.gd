extends TileMap

func _on_WallMech_dead(_killer):
	$EndPortal.show()


func _on_PortalTimer_timeout():
	$EndPortal.show()
