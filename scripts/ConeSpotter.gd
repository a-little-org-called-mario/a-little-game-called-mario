extends Spotter
class_name ConeSpotter
# Spotter that shows its detection range and makes sure
# there's nothing between it and the player before snitching

# It's not really a cone exdee
export(float) var cone_width: float = 128
export(float) var cone_length: float = 256
# Show detection range, make it transparent to avoid showing anything
export(Color) var cone_color: Color = Color.yellow
export(bool) var only_extremes: bool = true

# Assing anything to this variable to automatically look towards it
export(NodePath) var tracked_node setget set_tracking

export(bool) var cone_stops_at_tile: bool = false


func _ready():
	$TextureRect.rect_size.x = cone_length


func handle_setup():
	set_physics_process(false)
	# Create a triangle using the values set by the exported variables
	var cone := PoolVector2Array()
	cone.append(Vector2.ZERO)
	cone.append(Vector2(cone_length, cone_width * 0.5))
	cone.append(Vector2(cone_length, -cone_width * 0.5))
	# Assing the points to the collision shape and the polygon displaying thingie
	$CollisionPolygon2D.polygon = cone
	$TextureRect/Polygon2D.polygon = cone
	# Make cone less annoying by reducing opacity
	# Then assing the color to every vertex
	cone_color.a *= 0.33
	$TextureRect/Polygon2D.vertex_colors = [cone_color, cone_color, cone_color]
	if only_extremes:
		$TextureRect/Polygon2D.vertex_colors[0].a = 0.0
	# Polygon2D was made semi-transparent to be less annoying while making levels
	$TextureRect/Polygon2D.self_modulate = Color.white

	if tracked_node:
		set_tracking(get_node_or_null(tracked_node))


# Check if there's something between the cone's starting position and the player's
# It only detects things in the World collision layer (2nd one)
func check_valid_detection(body) -> bool:
	$RayCast2D.cast_to = $RayCast2D.to_local(body.global_position)
	$RayCast2D.force_raycast_update()
	var collider = $RayCast2D.get_collider()
	$RayCast2D.cast_to = Vector2(cone_length, 0)  # To reset to default position after check
	return collider is Player


func _process(delta: float) -> void:
	if cone_stops_at_tile:
		var collider = $RayCast2D.get_collider()
		var point: Vector2 = $RayCast2D.get_collision_point()
		if collider is TileMap:
			$TextureRect.rect_size.x = (point - position).y
		else:
			$TextureRect.rect_size.x = cone_length


# physics process is enabled only while there's something to track
func _physics_process(_delta: float):
	look_at(tracked_node.global_position)


func set_tracking(node: Node2D = null):
	tracked_node = node
	set_physics_process(tracked_node != null)


# Automatically hides itself while spoting is disabled
func disable_spoting():
	hide()
	.disable_spoting()


func enable_spoting():
	show()
	.enable_spoting()
