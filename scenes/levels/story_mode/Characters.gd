extends YSort

const Character = preload("res://scenes/levels/story_mode/character/Character.gd")

func get_by_id(id: String) -> Character:
	for character in get_children():
		if character.data.resource_path.get_file().get_basename() == id:
			return character
	return null
