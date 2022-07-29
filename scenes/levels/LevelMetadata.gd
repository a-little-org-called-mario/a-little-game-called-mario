# You need to create this resourse in level folder in scenes/levels
# Example: scenes/levels/{level_name}/metadata/metadata.tres
# Used to specify metadata in title/levelselect/LeveList.gd with FileUtils
extends Resource
class_name LevelMetadata

export (String, FILE, "*.tscn") var first_level_path
export (Array, String) var tags
export (String, MULTILINE) var short_description = " "
export (String, MULTILINE) var description = "No description ... yet"
export (Texture) var preview_image


func _init(level_path: String = "") -> void:
	self.first_level_path = level_path
