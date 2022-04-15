extends Node2D

var items : Dictionary

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
	
	for item in FileUtils.list_dir("res://scenes/levels/story_mode/items"):
		items[item.get_file().get_basename()] = load(item)


func _on_Character_talked_to(character: Character) -> void:
	if dialog_ui.dialog:
		return
	player.can_move = false
	var file = get_script().resource_path.get_base_dir().plus_file("dialogs").plus_file(character.dialog + ".json")
	var data := FileUtils.as_json(file)
	if not data:
		push_error("Couldn't load dialog of character %s: %s" % [character.title, file])
	dialog_ui.dialog = Dialog.new(data)
	dialog_ui.set_speaker(character)


func _on_DialogUI_dialog_finished() -> void:
	player.can_move = true


func _on_DialogUI_item_received(item_id: String) -> void:
	var item: StoryItem = items[item_id]
	item_receive_popup.show_for(item)
	yield(item_receive_popup, "confirmed")
	inventory.give(item)
