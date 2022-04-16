class_name EndPortal
extends Area2D

# You can use this to chain towards another level.
# When the player enters the Area2D, the current level will be unloaded and the
#  new one loaded in its place.
export(String, FILE) var next_level_path: String
onready var next_level: PackedScene = load(next_level_path) if len(next_level_path) > 0 else null

export var price: int

onready var mario: AnimatedSprite = $Mario


func _ready() -> void:
	$Sprite.play()
	$CoinContainer.visible = price > 0
	$CoinContainer/CoinLabel.text = str(price)


func _enter_tree() -> void:
	$Mario.visible = false


func can_enter(node: Node2D) -> bool:
	if not CoinInventoryHandle.change_coins_on(node, -price):
		return false

	return true


func on_portal_enter(_node: Node2D) -> AnimatedSprite:
	mario.visible = true
	mario.frame = 0
	mario.play()
	$PortalSFX.play()
	EventBus.emit_signal("level_completed", {})
	return mario
