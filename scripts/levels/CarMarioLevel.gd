extends Node2D

export (NodePath) var tilemap
export (Array, PackedScene) var random_spawns:= []
export (float) var tiles_per_lap:= 8
export (PackedScene) var coin_drops
export (PackedScene) var toll_scene
export (NodePath) var end_portal
export (int) var laps_to_win := 10

var _player
var _toll_booth
var tilemaps := []
var map_size := 0.0
var difficulty := 0

var old_stuff := []

func _ready():
	# YIKES SCOOB, LIKE WTF IS THIS CODE?
	if tilemap:
		tilemap= get_node_or_null(tilemap)
	if tilemap == null or !tilemap.has_node("PlayerCheck"):
		return
	map_size= tilemap.get_used_rect().size.x * tilemap.cell_size.x
	tilemap.get_node("PlayerCheck").connect("body_entered", self, "new_tile_entered", [tilemap])
	tilemaps.append(tilemap)
	for c in 2:
		var map= tilemap.duplicate()
		map.get_node("PlayerCheck").connect("body_entered", self, "new_tile_entered", [map])
		add_child(map)
		map.position.x= tilemap.position.x + map_size * (c+1)
		tilemaps.append(map)
	if toll_scene:
		_toll_booth= toll_scene.instance()
		add_child(_toll_booth)
		_toll_booth.position.x= map_size * tiles_per_lap + map_size
		var booth_start= get_node_or_null("BoothStart")
		_toll_booth.position.y= booth_start.position.y if booth_start else 128
		_toll_booth.connect("out_of_view", self, "_reposition_toll_booth")
		_toll_booth.connect("booth_passed", self, "_lap_completed")
	if has_node("Sponsor") and has_node("Meeting"):
		reposition_signs()

func new_tile_entered(player, current_map):
	_player= player
	
	for node in old_stuff.duplicate():
		if !is_instance_valid(node):
			old_stuff.erase(node)
		elif node.position.x <= (_player.position.x - map_size):
			node.call_deferred("queue_free")
			old_stuff.erase(node)
	
	if current_map == tilemaps[0]:
		tilemaps[1].position.x= current_map.position.x + map_size
		tilemaps[2].position.x= current_map.position.x + map_size * 2
	elif current_map == tilemaps[1]:
		tilemaps[0].position.x= current_map.position.x + map_size * 2
		tilemaps[2].position.x= current_map.position.x + map_size
	elif current_map == tilemaps[2]:
		tilemaps[1].position.x= current_map.position.x + map_size * 2
		tilemaps[0].position.x= current_map.position.x + map_size 
	if coin_drops:
		old_stuff.append(randomized_spawn(_player.position.x, coin_drops))
	if random_spawns:
		spawn_obstacles()

func spawn_obstacles():
	for o in (difficulty+1):
		var obj_id= randi() % min(difficulty+1, random_spawns.size()) as int
		var obstacle= random_spawns[obj_id]
		old_stuff.append(randomized_spawn(_player.position.x, obstacle))

func terrain_entered(body):
	if body.is_in_group("Player") and body.has_method("terrain_entered"):
		body.terrain_entered()

func terrain_exited(body):
	if body.is_in_group("Player") and body.has_method("terrain_exited"):
		body.terrain_exited()

func randomized_spawn(h_origin :float, scene :PackedScene) -> Node:
	var obj= scene.instance()
	call_deferred("add_child", obj)
	obj.position.x= h_origin + get_viewport().size.x * 1.15 + map_size * randf()
	obj.position.y= 132 + randf() * (get_viewport().size.y - 264)
	return obj

func _reposition_toll_booth():
	_toll_booth.position.x= (difficulty+1) * tiles_per_lap * map_size + map_size
	var portal= get_node_or_null(end_portal)
	if difficulty == (laps_to_win-1) and end_portal and has_node(end_portal):
		portal.position.x= (difficulty+1) * tiles_per_lap * map_size + map_size + 256

func _lap_completed():
	difficulty+= 1
	$CanvasLayer/Progress/Lap.bbcode_text= "[center][wave amp=50 freq=2]LAPS: %s[/wave][/center]" % difficulty
	_toll_booth.change_price(min(_toll_booth.price + 1, tiles_per_lap))
	$CanvasLayer/Progress/Price.bbcode_text= "[center][wave amp=50 freq=2]TOLL: %s[/wave][/center]" % _toll_booth.price

func reposition_signs():
	$Sponsor.rect_position.x= (laps_to_win/2.0) * tiles_per_lap * map_size + 256
	$Meeting.rect_position.x= (laps_to_win) * tiles_per_lap * map_size + 256
