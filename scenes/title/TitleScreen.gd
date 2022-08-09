extends Control
#export(int) var alternate_screen_chance
export(Array, String) var sprite_paths
export(Array, String) var label_texts
export(Array, String) var sfx_paths

const FileUtils = preload("res://scripts/FileUtils.gd")
const TextUtils = preload("res://scripts/TextUtils.gd")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Settings.load_data()
	if randf() < (1.0 / 5.0):
		alternate_title_screen()

func alternate_title_screen():
	#This function assumes that there is a matching number of sprites, labels, and sfx, and that the Mario Label, IdleMario Sprite, and Meow SFX are present in-scene, with the following paths. 
	if(label_texts.size() == sprite_paths.size() && sprite_paths.size() == sfx_paths.size()):
		var screen_index = randi() % label_texts.size()
		var mario_sprite = get_node("VBoxContainer/IdleMario")
		var size=mario_sprite.texture.get_size()
		mario_sprite.texture = ResourceLoader.load(sprite_paths[screen_index].rstrip(".import"), "Texture")
		var sizeto=mario_sprite.texture.get_size()
		var scale_factor = sizeto/size if sizeto < size else size/sizeto
		mario_sprite.scale=scale_factor
		var mario_label = get_node("VBoxContainer/Mario")
		mario_label.text = label_texts[screen_index]
		mario_label.bbcode_text = "\n" + TextUtils.center(TextUtils.wave(TextUtils.rainbow(mario_label.text)))
		var on_click_sfx = get_node("VBoxContainer/IdleMario/Meow")
		on_click_sfx.stream = ResourceLoader.load(sfx_paths[screen_index])
	else:
		return false
