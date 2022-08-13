extends Viewport

const SPAWNPOINTS_GROUP: String = "SpawnPoints"
const ENDPORTALS_GROUP: String = "EndPortals"
const COINS_GROUP: String = "Coins"
const PROJECTILES_GROUP: String = "Projectiles"

export(PackedScene) onready var hub = hub.instance()
export(PackedScene) var level_scene: PackedScene = null
export(NodePath) onready var level = get_node(level) as Node
onready var bgm: AudioStreamPlayer = $Audio/BGM
onready var defaultBGMStream: AudioStream = bgm.stream.duplicate()

onready var inventory: Resource = preload("res://scripts/resources/PlayerInventory.tres")
onready var reset_inventory: Resource = inventory.duplicate()

var entering_portal: bool = false


func _ready() -> void:
	EventBus.connect("build_block", self, "_on_build")
	EventBus.connect("bgm_changed", self, "_bgm_changed")
	EventBus.connect("restart_level", self, "_restart_level")
	EventBus.connect("level_exited", self, "_finish_level")
	EventBus.connect("level_changed", self, "_finish_level")
	Settings.load_data()
	_replace_level(level_scene.instance() if level_scene else hub)
	_hook_portals()
	VisualServer.set_default_clear_color(Color.black)
	randomize()


func _exit_tree() -> void:
	EventBus.emit_signal("game_exit")


func _bgm_changed(data) -> void:
	if typeof(data) == TYPE_STRING and data == "reset":
		bgm.stream = defaultBGMStream
		bgm.playing = true
	else:
		if "stream" in data:
			bgm.stream = data.stream
		if "playing" in data:
			bgm.playing = data.playing
			if data.playing:
				bgm.play()


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
		var target_tile_x = player_tile[0] + (1 if player.pivot.scale.x > 0 else -1)
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

	body.get_parent().remove_child(body)

	EventBus.emit_signal("level_completed", {})

	var animation: AnimationPlayer = portal.on_portal_enter(body)
	if animation == null:
		yield(get_tree().create_timer(1.0), "timeout")
	else:
		yield(animation, "animation_finished")
	call_deferred("_finish_level", next_level)


func _finish_level(next_level: PackedScene = null) -> void:
	# Set mouse mode as vissible by default, level can change it
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Create the new level, insert it into the tree and remove the old one.
	# If next_level is null, return to the hub
	level_scene = next_level
	var new_level: Node = level_scene.instance() if level_scene != null else hub
	_replace_level(new_level)
	# Do not forget to hook the new portals
	_hook_portals()
	#Update reset state of inventory
	reset_inventory = inventory.duplicate()
	#Removing instructions
	$UI/UI/Instructions.visible = false
	# Reset entering portal state
	entering_portal = false
	if new_level == hub:
		EventBus.emit_signal("hub_entered")
	else:
		EventBus.emit_signal("level_started", "")


func _replace_level(new_level: Node):
	if new_level != level:
		add_child_below_node(level, new_level)
		if level == hub:
			remove_child(level)
		else:
			level.queue_free()
			yield(level, "tree_exited")
		level = new_level
	else:
		var idx: int = level.get_index() - 1
		remove_child(level)
		add_child_below_node(get_child(idx), new_level)


func _restart_level() -> void:
	inventory.reset_to(reset_inventory)
	_finish_level(level_scene)
