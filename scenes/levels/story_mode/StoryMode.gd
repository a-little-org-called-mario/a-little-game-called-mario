extends Node2D

"""
Gamemode in which the story is what matters the most.

This script handles starting of dialogs by talking to characters.
"""

var _item_store := ItemStore.new("res://scenes/levels/story_mode/content/items")
var _door_cell : Vector2

const ItemStore = preload("item/ItemStore.gd")
const Dialog = preload("res://addons/dialog_importer/dialog.gd")
const Character = preload("character/Character.gd")
const DialogUI = preload("dialog/DialogUI.gd")
const Inventory = preload("item/Inventory.gd")
const TopDownPlayer = preload("player/TopDownPlayer.gd")
const ItemReceivePopup = preload("item/ItemReceivePopup.gd")

onready var _player: TopDownPlayer = $YSort/TopDownPlayer
onready var _dialog_ui: DialogUI = $CanvasLayer/UI/DialogUI
onready var _inventory: Inventory = $CanvasLayer/UI/Inventory
onready var _item_receive_popup: ItemReceivePopup = $CanvasLayer/UI/ItemReceivePopup
onready var _tile_map: TileMap = $TileMap
onready var _door_position: Position2D = $DoorPosition
onready var _characters: YSort = $YSort/Characters
onready var _cut_scene_player: AnimationPlayer = $CutScenePlayer
onready var _cut_scene_focus: Position2D = $CutSceneFocus
onready var _cut_scene_camera: Camera2D = $CutSceneCamera
onready var _room_camera: Camera2D = $RoomCamera


func _ready() -> void:
	_door_cell = _tile_map.world_to_map(_door_position.position)
	for character in $YSort/Characters.get_children():
		character.connect("talked_to", self, "_on_Character_talked_to",
				[character])
	for item in $YSort/Items.get_children():
		item.connect("picked_up", self, "_on_GroundItem_picked_up", [item])
	_dialog_ui.init(_item_store, _characters, _inventory,
			"res://scenes/levels/story_mode/content/dialogs/")


func is_door_open():
	return _tile_map.get_cellv(_door_cell) == 1


func open_door():
	_tile_map.set_cellv(_door_cell, 1)


func _on_Character_talked_to(character: Character) -> void:
	if _dialog_ui.active:
		return
	_dialog_ui.start(character.dialog, character)


func _on_GroundItem_picked_up(item):
	item.queue_free()
	_give_with_dialog(item.item)


func _give_with_dialog(item):
	_item_receive_popup.show_for(item)
	yield(_item_receive_popup, "confirmed")
	_inventory.give(item)


func _on_DialogUI_dialog_finished() -> void:
	_player.can_move = true


func _on_DialogUI_item_received(item_id: String) -> void:
	_give_with_dialog(_item_store.get(item_id))


func _on_DialogUI_event_occured(event) -> void:
	if _cut_scene_player.has_animation(event):
		_player.can_move = false
		_cut_scene_focus.position = _room_camera.position
		_cut_scene_camera.position = _room_camera.position
		_cut_scene_player.play(event)
		_cut_scene_camera.make_current()
		yield(_cut_scene_player, "animation_finished")
		_player.can_move = true
		_room_camera.make_current()


func _on_DialogUI_dialog_started() -> void:
	_player.can_move = false
