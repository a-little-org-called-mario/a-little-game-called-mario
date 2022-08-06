extends Node2D
class_name SokobanLevel, "res://sprites/box.png"


signal box_moved(from_pos, to_pos)


export(PackedScene) var level_select_menu

export(NodePath) onready var ground = get_node(ground) as TileMap
export(String) onready var hole_tile = ground.tile_set.find_tile_by_name(hole_tile) as int

export(NodePath) onready var boxes = get_node(boxes) as TileMap
export(String) onready var box_tile = boxes.tile_set.find_tile_by_name(box_tile) as int

export(NodePath) onready var player = get_node(player) as SokobanPlayer

onready var total_boxes = boxes.get_used_cells_by_id(box_tile).size()
onready var tile_size = ground.cell_size * ground.scale


enum UNDO {
	PLAYER_MOVE,
	BOX_MOVE
}

var correct_boxes = 0
var undo_stack := []
var current_move := {
	UNDO.PLAYER_MOVE: null,  # {position: int}
	UNDO.BOX_MOVE: null  # {old_pos: int, new_pos: int}
}


func _ready():
	EventBus.emit_signal("bgm_changed", {"playing": false})


func _process(delta):
	if Input.is_action_just_pressed("undo"):
		undo()
	elif Input.is_action_just_pressed("restart"):
		EventBus.emit_signal("restart_level")


func move_player(move_direction: Vector2):
	var to_dir = move_direction * tile_size
	var collider := _get_collision(player.global_position, to_dir)

	if collider == ground:
		return

	if collider == boxes:
		var success = move_box(player.global_position + to_dir, to_dir)
		if not success:
			return

	_add_player_move_undo(player.position)
	player.position += to_dir
	_commit_current_move()


func move_box(from_pos: Vector2, to_dir: Vector2) -> bool:
	var something_behind_box := _get_collision(from_pos, to_dir)
	if something_behind_box:
		return false

	var local_pos: Vector2 = boxes.to_local(from_pos)
	var old_pos: Vector2 = boxes.world_to_map(local_pos)
	var new_pos: Vector2 = boxes.world_to_map(local_pos + to_dir)
	
	_swap_box_tiles(old_pos, new_pos)
	_add_box_move_undo(old_pos, new_pos)
	return true


func _swap_box_tiles(old_cellv: Vector2, new_cellv: Vector2):
	boxes.set_cellv(old_cellv, -1)
	boxes.set_cellv(new_cellv , box_tile)
	boxes.update_dirty_quadrants()
	emit_signal("box_moved", old_cellv, new_cellv)


func _get_collision(from_pos: Vector2, to_dir: Vector2) -> TileMap:
	var intersections: Array = (
		get_world_2d().get_direct_space_state().intersect_point(from_pos + to_dir)
	)
	for intersection in intersections:
		if intersection.collider is TileMap:
			return intersection.collider
	return null


func _on_box_moved(from_pos: Vector2, to_pos: Vector2) -> void:
	if ground.get_cellv(from_pos) == hole_tile:
		correct_boxes -= 1
	if ground.get_cellv(to_pos) == hole_tile:
		correct_boxes += 1
	if correct_boxes == total_boxes:
		win()


func _add_player_move_undo(pos: Vector2) -> void:
	current_move[UNDO.PLAYER_MOVE] = {
		position=pos
	}


func _add_box_move_undo(old_pos: Vector2, new_pos: Vector2) -> void:
	current_move[UNDO.BOX_MOVE] = {
		old_pos=old_pos,
		new_pos=new_pos
	}


func _commit_current_move() -> void:
	undo_stack.append(current_move.duplicate(true))
	current_move = {}


func close_level():
	EventBus.emit_signal("bgm_changed", "reset")
	EventBus.emit_signal("level_changed", level_select_menu)


func win():
	close_level()


func restart():
	get_tree().reload_current_scene()


func undo():
	var last_move = undo_stack.pop_back()
	if not last_move:
		return
	for type in last_move:
		var move = last_move[type]
		if not move:
			continue
		match type:
			UNDO.PLAYER_MOVE:
				player.set_position(move.position)
			UNDO.BOX_MOVE:
				_swap_box_tiles(move.new_pos, move.old_pos)
