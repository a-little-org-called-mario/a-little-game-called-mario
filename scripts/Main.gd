extends Viewport

const SPAWNPOINTS_GROUP: String = "SpawnPoints"
const ENDPORTALS_GROUP: String = "EndPortals"
const COINS_GROUP: String = "Coins"
const PROJECTILES_GROUP: String = "Projectiles"

onready var hub: TileMap = $TileMap
onready var level: Node = $TileMap
onready var bgm: AudioStreamPlayer = $Audio/BGM
onready var ui: CanvasLayer = $UI

var completionSound = preload("res://audio/sfx/portal.wav")
var coinSound = preload("res://audio/sfx/coin.wav")

var entering_portal: bool = false


func _ready() -> void:
	EventBus.connect("build_block", self, "_on_build")
	EventBus.connect("bgm_changed", self, "_bgm_changed")
	EventBus.connect("ui_visibility_changed", self, "_on_ui_visibility_changed")
	_hook_portals()
	VisualServer.set_default_clear_color(Color.black)


func _exit_tree() -> void:
	EventBus.emit_signal("game_exit")


func _on_ui_visibility_changed(data):
	ui.get_child(0).visible = data.visible


func _bgm_changed(data) -> void:
	if "playing" in data:
		bgm.playing = data.playing
	if "stream" in data:
		bgm.stream = data.stream


func _hook_portals() -> void:
	for portal in get_tree().get_nodes_in_group(ENDPORTALS_GROUP):
		# Avoid objects that should not be in the group.
		if not portal is EndPortal:
			continue
		# Avoid connecting the same object several times.
		if portal.is_connected("body_entered", self, "_on_endportal_body_entered"):
			continue
		portal.connect(
			"body_entered", self, "_on_endportal_body_entered", [portal.next_level, portal]
		)


func _on_build(data) -> void:
	var player = data["player"]
	# reference to player is needed for the case where there are more than one player
	# eg. Level03

	# place a block in the level.
	if level != null:
		# Find the player's current position on the tilemap, and look one cell
		# to the left or right depending on which direction the player sprite
		# is facing.
		var player_tile = level.world_to_map(player.position)
		var target_tile_x = player_tile[0] + 1
		if player.sprite.flip_h:
			target_tile_x = player_tile[0] - 1
		var target_tile_y = player_tile[1]
		var target_cell_v = level.get_cell(target_tile_x, target_tile_y)
		if target_cell_v == 0:
			# If the cell is empty, place a block
			level.set_cell(target_tile_x, target_tile_y, 1)
		elif target_cell_v == 1:
			# If the cell has a block in in, break the block.
			level.set_cell(target_tile_x, target_tile_y, 0)


func _on_endportal_body_entered(body: Node2D, next_level: PackedScene, portal: EndPortal) -> void:
	# Make sure the player can't trigger this function more than once.
	if entering_portal || not portal.can_enter(body):
		return
	entering_portal = true

	# Despawn all projectiles
	for despawn in get_tree().get_nodes_in_group(PROJECTILES_GROUP):
		despawn.queue_free()

	var animation = portal.on_portal_enter(body)
	body.get_parent().remove_child(body)

	yield(animation, "animation_finished")
	call_deferred("_finish_level", next_level)


func _finish_level(next_level: PackedScene = null) -> void:
	# Create the new level, insert it into the tree and remove the old one.
	# If next_level is null, return to the hub
	var new_level: Node = next_level.instance() if next_level != null else hub
	add_child_below_node(level, new_level)
	if level == hub:
		remove_child(level)
	else:
		level.queue_free()
		yield(level, "tree_exited")
	level = new_level
	if level == hub:
		for c in level.get_children():
			if c is SpawnPoint:
				c.spawn_mario()
				break

	# Do not forget to hook the new portals
	_hook_portals()

	#Removing instructions
	$UI/UI/Instructions.visible = false

	# Reset entering portal state
	entering_portal = false
	EventBus.emit_signal("level_started", {})
