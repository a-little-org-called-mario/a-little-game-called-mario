extends Node2D

const Dialog = preload("dialog/Dialog.gd")
const Character = preload("character/Character.gd")

onready var player: KinematicBody2D = $TopDownPlayer
onready var dialog_ui: Control = $CanvasLayer/DialogUI

func _ready() -> void:
	for character in $Characters.get_children():
		character.connect("talked_to", self, "_on_Character_talked_to",
				[character])


func _on_Character_talked_to(character: Character) -> void:
	if dialog_ui.dialog:
		return
	player.can_move = false
	var file = get_script().resource_path.get_base_dir().plus_file("dialogs").plus_file(character.dialog + ".json")
	var data := as_json(file)
	if not data:
		push_error("Couldn't load dialog of character %s: %s" % [character.title, file])
	dialog_ui.dialog = Dialog.new(data)
	dialog_ui.set_speaker(character)


func _on_DialogUI_dialog_finished() -> void:
	player.can_move = true


# Returns the content of a file as a json object.
static func as_json(path : String) -> Dictionary:
	var file := File.new()
	if file.open(path, File.READ) != OK:
		return {}
	var text := file.get_as_text()
	file.close()
	return parse_json(text)
