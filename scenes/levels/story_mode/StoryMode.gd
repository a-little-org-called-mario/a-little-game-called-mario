extends Node2D

"""@wiki
Gamemode in which the story is what matters the most.

## Adding Characters

## Adding Dialogs

## Adding Items
"""

var _item_store := ItemStore.new()

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

func _ready() -> void:
	for character in $Characters.get_children():
		character.connect("talked_to", self, "_on_Character_talked_to",
				[character])
	_dialog_ui.set_items(_item_store)
	_dialog_ui.set_inventory(_inventory)
	_dialog_ui.start("intro")


func _on_Character_talked_to(character: Character) -> void:
	if _dialog_ui.active:
		return
	_player.can_move = false
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
		_tile_map.set_cell(20, -11, 1)
