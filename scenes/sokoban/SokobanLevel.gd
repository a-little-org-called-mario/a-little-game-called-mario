extends Node2D
class_name SokobanLevel, "res://sprites/box.png"

export(int) var total_boxes = 0
var correct_boxes = 0

onready var ground_map: TileMap = get_tree().get_nodes_in_group("ground")[0]
onready var hole_id: int = ground_map.tile_set.find_tile_by_name("Hole")


func _ready():
	$SokobanPlayer.connect("box_moved", self, "_on_box_moved")


func _on_box_moved(from, to):
	if ground_map.get_cell(from.x, from.y) == hole_id:
		correct_boxes -= 1
	if ground_map.get_cell(to.x, to.y) == hole_id:
		correct_boxes += 1

	if correct_boxes == total_boxes:
		win()


func win():
	EventBus.emit_signal("change_scene", {"scene": "res://scenes/sokoban/SokobanMain.tscn"})
