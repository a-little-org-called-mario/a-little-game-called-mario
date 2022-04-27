class_name IntralevelPortal
extends Area2D

# Use this to teleport the player to a Vector2 on the current level
export var teleport_to: Vector2


func _ready():
	$Sprite.play()
	connect("body_entered", self, "_on_portal_enter")


func _on_portal_enter(body) -> void:
	if body is Player:
		call_deferred("teleport", body)


func teleport(player: Player) -> void:
	$PortalSFX.play()
	player.position.x = teleport_to.x * 64
	player.position.y = teleport_to.y * 64
