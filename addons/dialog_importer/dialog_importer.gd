tool
extends EditorImportPlugin

const Dialog = preload("dialog.gd")

func get_importer_name():
	return "littlgameemario.dialog"


func get_visible_name():
	return "Dialog"


func get_recognized_extensions():
	return ["json"]


func get_save_extension():
	return "res"


func get_resource_type():
	return "Resource"


func import(source_file: String, save_path: String, options: Dictionary,
		platform_variants: Array, gen_files: Array) -> int:
	var data := as_json(source_file)
	if not data:
		return ERR_FILE_CORRUPT
	return ResourceSaver.save(save_path + ".res", Dialog.new(data))


func get_preset_count():
	return 1


func get_preset_name(preset):
	return "Default"


func get_import_options(preset):
	return []


# Returns the content of a file as a json object.
static func as_json(path: String) -> Dictionary:
	var file := File.new()
	if file.open(path, File.READ) != OK:
		return {}
	var text := file.get_as_text()
	file.close()
	return parse_json(text)
