extends Node2D

"""@wiki
Gamemode in which the story is what matters the most.

## Adding Characters

## Adding Dialogs

## Adding Items
"""

var _item_store := ItemStore.new()
var _door_cell : Vector2

const ItemStore = preload("items/ItemStore.gd")
const Dialog = preload("dialog/Dialog.gd")
const Character = preload("character/Character.gd")
const DialogUI = preload("dialog/DialogUI.gd")
const Inventory = preload("items/Inventory.gd")
const TopDownPlayer = preload("player/TopDownPlayer.gd")
const ItemReceivePopup = preload("items/ItemReceivePopup.gd")

onready var _player: TopDownPlayer = $TopDownPlayer
onready var _dialog_ui: DialogUI = $CanvasLayer/UI/DialogUI
onready var _inventory: Inventory = $CanvasLayer/UI/Inventory
onready var _item_receive_popup: ItemReceivePopup = $CanvasLayer/UI/ItemReceivePopup
onready var _tile_map: TileMap = $TileMap
onready var _door_position: Position2D = $DoorPosition


func _ready() -> void:
	_door_cell = _tile_map.world_to_map(_door_position.position)
	for character in $Characters.get_children():
		character.connect("talked_to", self, "_on_Character_talked_to",
				[character])
	_dialog_ui.init(_item_store, _inventory)
	_dialog_ui.start("intro")


func is_door_open():
	return _tile_map.get_cellv(_door_cell) == 1


func _on_Character_talked_to(character: Character) -> void:
	if _dialog_ui.active:
		return
	_dialog_ui.start(character.dialog, character)


func _on_DialogUI_dialog_finished() -> void:
	_player.can_move = true


func _on_DialogUI_item_received(item_id: String) -> void:
	var item: StoryItem = _item_store.get(item_id)
	_item_receive_popup.show_for(item)
	yield(_item_receive_popup, "confirmed")
	_inventory.give(item)


func _on_DialogUI_event_occured(event) -> void:
	if event == "open_door":
		_tile_map.set_cellv(_door_cell, 1)


func _on_DialogUI_dialog_started() -> void:
	_player.can_move = false
