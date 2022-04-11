extends TileMap

const PORTAL_POSITION: Vector2 = Vector2(6, 4)
const COPY_ZONE_START: Vector2 = Vector2(5, -1)
const COPY_ZONE_END: Vector2 = Vector2(7, 9)
const WALL_START: Vector2 = Vector2(7, -1)
const WALL_END: Vector2 = Vector2(8, 9)

export(String, DIR) var levels_directory: String
export(PackedScene) var portal_scene: PackedScene


func _ready() -> void:
	var copy_zone := _copy_zone(COPY_ZONE_START, COPY_ZONE_END)
	var wall_zone := _copy_zone(WALL_START, WALL_END)

	var levels := _get_all_first_levels_in_dir(levels_directory)
	var shift: int = 0
	for level in levels:
		_paste_zone(copy_zone, Vector2(COPY_ZONE_START.x + shift, COPY_ZONE_START.y))
		var portal: EndPortal = portal_scene.instance()
		portal.global_position = (
			map_to_world(Vector2(PORTAL_POSITION.x + shift, PORTAL_POSITION.y))
			+ (cell_size / 2)
		)
		portal.next_level = load(level)
		add_child(portal)
		shift += int(floor(COPY_ZONE_END.x - COPY_ZONE_START.x + 1))
	_paste_zone(wall_zone, Vector2(COPY_ZONE_START.x + shift, COPY_ZONE_START.y))


func _copy_zone(topleft: Vector2, bottomright: Vector2) -> Array:
	var cells := []
	for x in range(topleft.x, bottomright.x + 1):
		var column := []
		for y in range(topleft.y, bottomright.y + 1):
			column.append(get_cell(x, y))
		cells.append(column)
	return cells



func _paste_zone(zone: Array, topleft: Vector2) -> void:
	for x in range(0, len(zone)):
		for y in range(0, len(zone[0])):
			set_cell(
				int(floor(topleft.x + x)), 
				int(floor(topleft.y + y)),
				zone[x][y]
			)


static func _get_all_first_levels_in_dir(path: String) -> Array:
	var levels := []
	var dir := Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var filename := dir.get_next()
		while filename != "":
			if filename != "." and filename != ".." and dir.current_is_dir():
				var level := _get_first_level_in_dir("%s/%s" % [path, filename])
				if len(level) > 0:
					levels.append(level)
			filename = dir.get_next()
		dir.list_dir_end()

	levels.sort()
	return levels


static func _get_first_level_in_dir(path: String) -> String:
	var dir := Directory.new()
	var levels := []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var filename := dir.get_next()
		while filename != "":
			if filename != "." and filename != ".." and !dir.current_is_dir():

				levels.append("%s/%s" % [path, filename])
			filename = dir.get_next()
		dir.list_dir_end()
	# note[apple]: Directory order is not the same on all platforms. On Linux, for some reason,
	# not sorting the list means that the last level gets returned first
	if len(levels) > 0:
		levels.sort()
		return levels[0]
	else:
		return ""
