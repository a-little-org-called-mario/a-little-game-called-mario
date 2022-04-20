extends Node2D
class_name SokobanLevel, "res://sprites/box.png"

enum UNDO_TYPE {
	PLAYER_MOVE,
	BOX_MOVE,
	SCORE
}

enum UNDO_INDEX {
	MOVES,
	TYPE,
	NODE,
	PREVIOUS_POS,
	CURRENT_POS
}


export(int) var total_boxes = 0
var correct_boxes = 0

onready var ground_map: TileMap = get_tree().get_nodes_in_group("ground")[0]
onready var hole_id: int = ground_map.tile_set.find_tile_by_name("Hole")

onready var CurrentMove := 0
onready var UndoArray := []

onready var PlayerNode = $SokobanPlayer
onready var BoxMap = $Boxes
onready var BoxID: int = BoxMap.tile_set.find_tile_by_name("Box")

func _ready():
	PlayerNode.connect("box_moved", self, "_on_box_moved")
	PlayerNode.connect("player_moved", self, "_on_player_moved")

func addPlayerMoveUndo(PreviousPosition:Vector2):
	UndoArray.append([CurrentMove,UNDO_TYPE.PLAYER_MOVE,PlayerNode,PreviousPosition])

func addBoxMoveUndo(PreviousPosition:Vector2,NextPosition:Vector2):
	UndoArray.append([CurrentMove,UNDO_TYPE.BOX_MOVE,null,PreviousPosition,NextPosition])
	
func _on_player_moved(PreviousPosition:Vector2):
	addPlayerMoveUndo(PreviousPosition)
	CurrentMove += 1

func _on_box_moved(from, to, addUndo=true):
	if addUndo:
		addBoxMoveUndo(from, to)
	
	if ground_map.get_cell(from.x, from.y) == hole_id:
		correct_boxes -= 1
	if ground_map.get_cell(to.x, to.y) == hole_id:
		correct_boxes += 1

	if correct_boxes == total_boxes:
		win()

func _process(delta):
	if Input.is_action_just_pressed("undo"):
		undo()
	elif Input.is_action_just_pressed("restart"):
		restart()
	if Input.is_action_just_pressed("pause"):
		close_level()


func close_level():
	EventBus.emit_signal("change_scene", {"scene": "res://scenes/sokoban/SokobanMain.tscn"})


func win():
	close_level()


func restart():
	get_tree().reload_current_scene()


func undo():
	if UndoArray.size() > 0: #Can Undo
		CurrentMove -= 1
		
		var UndosToRemove := []
		
		for Undo in UndoArray:
			if Undo[UNDO_INDEX.MOVES] == CurrentMove:
				match Undo[UNDO_INDEX.TYPE]:
					UNDO_TYPE.PLAYER_MOVE: Undo[UNDO_INDEX.NODE].set_position(Undo[UNDO_INDEX.PREVIOUS_POS])
					UNDO_TYPE.BOX_MOVE: processBoxUndo(Undo[UNDO_INDEX.PREVIOUS_POS],Undo[UNDO_INDEX.CURRENT_POS])
					
				UndosToRemove.append(Undo)
			
		for Undo in UndosToRemove:
			UndoArray.erase(Undo)

func processBoxUndo(PreviousPosition,CurrentPosition):
	BoxMap.set_cellv(CurrentPosition, -1) #Removes box from current tileset
	BoxMap.set_cellv(PreviousPosition, BoxID) 
	
	_on_box_moved(CurrentPosition,PreviousPosition,false)
