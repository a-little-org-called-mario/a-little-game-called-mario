#warning-ignore-all: NARROWING_CONVERSION
#warning-ignore-all: INTEGER_DIVISION
extends TileMap


const LABEL_POSITION := Vector2(6, 6)
const TUTORIAL_NAME = "TUTORIAL"
const FileUtils = preload("res://scripts/FileUtils.gd")

export(String, DIR) var levels_directory: String
export(PackedScene) var portal_scene: PackedScene
export(NodePath) var walls_tilemap_path: NodePath
export(NodePath) var portal_template_path: NodePath

var generated: bool = false


func _ready() -> void:
	var walls_tilemap: TileMap = get_node(walls_tilemap_path)
	var portal_template: TileMap = get_node(portal_template_path)
	var portal_rect: Rect2 = portal_template.get_used_rect()
	var portal_position: Vector2 = portal_template.get_node("Portal").position
	var label_position: Vector2 = portal_template.get_node("Label").position

	var levels: Dictionary = { }
	for level in FileUtils.get_all_first_levels_in_dir(levels_directory):
		var level_name = FileUtils.get_dir_name(level).to_upper()
		if level_name == TUTORIAL_NAME:
			continue
		levels[level_name] = level

	var n_levels: int = len(levels)
	var keys: Array = levels.keys()
	keys.sort()

	for i in range(n_levels):
		var rect: Rect2 = walls_tilemap.get_used_rect()
		var base_dest: Vector2 = Vector2(
			rect.position.x + (rect.size.x if i >= n_levels / 2 else -portal_rect.size.x),
			rect.position.y + rect.size.y - 1.0
		)
		for y in range(portal_rect.size.y):
			for x in range(portal_rect.size.x):
				var dest_x := base_dest.x + x
				var dest_y := base_dest.y - y
				var tile := portal_template.get_cell(
					portal_rect.position.x + x,
					portal_rect.position.y + portal_rect.size.y - 1 - y
				)
				walls_tilemap.set_cell(dest_x, dest_y, tile)
		create_portal(levels[keys[i]], map_to_world(base_dest) + portal_position)
		create_label(keys[i], map_to_world(base_dest) + label_position)

	# Update left/right labels
	$LeftLabel.bbcode_text = TextUtils.wave("< %s-%s" % [
		keys[(n_levels / 2) - 1].substr(0, 1), 
		keys[0].substr(0, 1)
	])
	$RightLabel.bbcode_text = TextUtils.right(TextUtils.wave("%s-%s >" % [
		keys[n_levels / 2].substr(0, 1),
		keys[n_levels - 1].substr(0, 1)
	]))

	# Fill everything with background tile.
	# And put walls around the room.
	var full_rect: Rect2 = walls_tilemap.get_used_rect()
	for y in range(full_rect.size.y):
		for x in range(full_rect.size.x):
			var cell: Vector2 = Vector2(full_rect.position.x + x, full_rect.position.y + y)
			if x == 0 or x == full_rect.size.x - 1 or y == 0 or y == full_rect.size.y - 1:
				walls_tilemap.set_cellv(cell, 0)
			set_cellv(cell, 1)
	portal_template.queue_free()

	generated = true
	_set_camera_limits()

func _enter_tree() -> void:
	if not generated:
		return
	_set_camera_limits()


func _exit_tree() -> void:
	_unset_camera_limits()


func create_portal(level: String, position: Vector2) -> EndPortal:
	var portal: EndPortal = portal_scene.instance()
	portal.next_level_path = level
	portal.global_position = position
	add_child(portal)
	return portal


func create_label(text: String, position: Vector2) -> Label:
	var label: Label = Label.new()
	label.add_font_override("font", preload("res://scenes/ui/Themes/Default/DefaultFont.tres"))
	label.uppercase = true
	label.text = text
	label.set_global_position(position + Vector2(0.0, cell_size.y / 4.0))
	add_child(label)
	label.set_global_position(label.rect_global_position - Vector2(label.rect_size.x / 2.0, 0.0))
	return label


func _set_camera_limits() -> void:
	var camera: Camera2D = $CameraFollow.camera_reference
	if camera != null:
		var rect: Rect2 = (get_node(walls_tilemap_path) as TileMap).get_used_rect()
		var topleft: Vector2 = map_to_world(rect.position)
		var bottomright: Vector2 = map_to_world(rect.position + rect.size)
		camera.limit_bottom = bottomright.y
		camera.limit_left = topleft.x
		camera.limit_right = bottomright.x


func _unset_camera_limits() -> void:
	var camera: Camera2D = $CameraFollow.camera_reference
	if camera != null:
		camera.limit_bottom = 10000000
		camera.limit_left = -10000000
		camera.limit_right = 10000000
