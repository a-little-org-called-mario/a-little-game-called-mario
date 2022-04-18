extends Node2D

var item_store := ItemStore.new()

const ItemStore = preload("res://scenes/levels/story_mode/ItemStore.gd")
const Dialog = preload("dialog/Dialog.gd")
const Character = preload("character/Character.gd")
const FileUtils = preload("res://scripts/FileUtils.gd")

onready var player: KinematicBody2D = $TopDownPlayer
onready var dialog_ui: Control = $CanvasLayer/DialogUI
onready var inventory: ColorRect = $CanvasLayer/Inventory
onready var item_receive_popup: AcceptDialog = $CanvasLayer/ItemReceivePopup

func _ready() -> void:
	for character in $Characters.get_children():
		character.connect("talked_to", self, "_on_Character_talked_to",
				[character])
	dialog_ui.set_items(item_store)


func _on_Character_talked_to(character: Character) -> void:
	if dialog_ui.active:
		return
	player.can_move = false
	var file = get_script().resource_path.get_base_dir().plus_file("dialogs").plus_file(character.dialog + ".json")
	var data := FileUtils.as_json(file)
	if not data:
		push_error("Couldn't load dialog of character %s: %s" % [character.title, file])
	dialog_ui.start(character, Dialog.new(data))


func _on_DialogUI_dialog_finished() -> void:
	player.can_move = true


func _on_DialogUI_item_received(item_id: String) -> void:
	var item: StoryItem = item_store.get(item_id)
	item_receive_popup.show_for(item)
	yield(item_receive_popup, "confirmed")
	inventory.give(item)


func _on_DialogUI_event_occured(event) -> void:
	if event == "open_door":
		$TileMap.set_cell(20, -11, 1)
