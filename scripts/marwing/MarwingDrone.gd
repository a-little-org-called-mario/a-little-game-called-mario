extends MarwingShipBase

# random ranges
export var max_speed_ceiling: float = 5;
export var h_offset_range: float = 20;

func _on_Hitbox_area_entered(projectile: MarwingProjectile):
	if projectile and not invulnerable:
		self.hp -= projectile.damage

func _ready():
	print("Drone Spawned!")
	forward_speed = rand_range(1,max_speed_ceiling)
	rotate_y(deg2rad(-90))
	rotate_z(deg2rad(-30))
	unit_offset = rand_range(0,1)
	h_offset = rand_range(-h_offset_range, h_offset_range)
