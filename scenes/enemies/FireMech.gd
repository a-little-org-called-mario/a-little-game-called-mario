extends "res://scripts/WallMech.gd"


var player: Player = null


func shoot() -> void:
	if player:  # Calculate shooting_direction based on player position
		shoot_direction = position.direction_to(player.position) * Vector2(1, 0)
	.shoot()


#warning-ignore:SHADOWED_VARIABLE
func _on_SpawnPoint_player_spawned(player):
	self.player = player
