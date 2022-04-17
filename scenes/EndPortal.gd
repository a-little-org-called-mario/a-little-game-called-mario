tool
class_name EndPortal
extends Area2D

enum PortalColors {
	Default = 0x3458AD,
	Hub = 0x1CD76E,
}

# You can use this to chain towards another level.
# When the player enters the Area2D, the current level will be unloaded and the
#  new one loaded in its place.
export(String, FILE) var next_level_path: String setget _set_next_level_path
export(int) var price: int
export(Color) var color: Color = Color.black setget _set_color

onready var next_level: PackedScene = load(next_level_path) if len(next_level_path) > 0 else null
onready var mario: AnimatedSprite = $Mario


func _ready() -> void:
	$Sprite.play()

	update_portal_color()

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


func portal_color() -> Color:
	if color != Color.black:
		return color
	if len(next_level_path) <= 0:
		return Color("#%x" % PortalColors.Hub)
	return Color("#%x" % PortalColors.Default)


func update_portal_color() -> void:
	var sprite: AnimatedSprite = $Sprite
	var updated_color: Color = portal_color()
	if sprite.material.get_shader_param("colour") == updated_color:
		return
	sprite.material.set_shader_param("colour", portal_color())


func _set_next_level_path(path: String) -> void:
	next_level_path = path
	update_portal_color()


func _set_color(new_color: Color) -> void:
	color = new_color
	update_portal_color()
