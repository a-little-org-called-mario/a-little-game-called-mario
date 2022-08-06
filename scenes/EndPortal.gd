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

# This is used from outside this class
#warning-ignore:UNUSED_CLASS_VARIABLE
onready var next_level: PackedScene = load(next_level_path) if len(next_level_path) > 0 else null
onready var sprite: Sprite = $PlayerSprite
onready var animationplayer: AnimationPlayer = $PlayerSprite/AnimationPlayer


func _ready() -> void:
	$PortalSprite.play()

	update_portal_color()

	$CoinContainer.visible = price > 0
	$CoinContainer/CoinLabel.text = str(price)


func can_enter(node: Node2D) -> bool:
	if not visible:
		return false
	if not CoinInventoryHandle.change_coins_on(node, -price):
		return false

	return true


func on_portal_enter(node: Node2D) -> AnimationPlayer:
	$PortalSFX.play()

	var player_sprite = (
		node.get_node_or_null("Sprite")
		if not node as Player
		else (node as Player).sprite
	)

	if player_sprite as Sprite:
		sprite.texture = player_sprite.texture
		sprite.hframes = player_sprite.hframes
		sprite.vframes = player_sprite.vframes
		sprite.frame = player_sprite.frame
	elif player_sprite as AnimatedSprite:
		sprite.texture = player_sprite.frames.get_frame(
			player_sprite.animation, player_sprite.frame
		)
		sprite.hframes = 1
		sprite.vframes = 1
		sprite.frame = 0
	else:
		return null

	animationplayer.play("Swirl")
	node.queue_free()
	return animationplayer


func portal_color() -> Color:
	if color != Color.black:
		return color
	if len(next_level_path) <= 0:
		return Color("#%x" % PortalColors.Hub)
	return Color("#%x" % PortalColors.Default)


func update_portal_color() -> void:
	var portalsprite: AnimatedSprite = $PortalSprite
	var updated_color: Color = portal_color()
	if portalsprite.material.get_shader_param("colour") == updated_color:
		return
	portalsprite.material.set_shader_param("colour", portal_color())


func _set_next_level_path(path: String) -> void:
	next_level_path = path
	update_portal_color()


func _set_color(new_color: Color) -> void:
	color = new_color
	update_portal_color()
