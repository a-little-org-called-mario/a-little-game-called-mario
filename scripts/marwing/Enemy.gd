extends MarwingShip


func _on_Hitbox_area_entered(projectile: MarwingProjectile):
	if projectile and not invulnerable:
		self.hp -= projectile.damage
