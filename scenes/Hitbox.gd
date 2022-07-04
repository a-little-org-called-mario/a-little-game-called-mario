extends Area2D


func _on_Hitbox_entered(enemy):
	var damage = enemy.damage if "damage" in enemy else 1
	HeartInventoryHandle.change_hearts_on(owner, -damage)
