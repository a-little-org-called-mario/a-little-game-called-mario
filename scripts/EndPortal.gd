class_name EndPortal
extends Area2D

# You can use this to chain towards another level.
# When the player enters the Area2D, the current level will be unloaded and the
#  new one loaded in its place.
export var next_level: PackedScene

onready var mario: AnimatedSprite = $Mario


func _ready():
	$Sprite.play()


func _enter_tree() -> void:
	$Mario.visible = false


func on_portal_enter():
	mario.visible = true
	mario.frame = 0
	mario.play()
	$PortalSFX.play()
	EventBus.emit_signal("level_completed", {})
	return mario
