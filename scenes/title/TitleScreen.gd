extends Control
#export(int) var alternate_screen_chance
export(Array, String) var alt_sprite_paths = ["res://sprites/large-gassy-randal.png"]
export(Array, String) var alt_label_texts
export(Array, String) var alt_sound_effect_paths

func _ready():
	#randomize()
	Settings.load_data()
	if true:
		alternate_title_screen()

func alternate_title_screen():
	#This function assumes that there is a matching number of sprites, labels, and sfx, and that the Mario Label, IdleMario Sprite, and Meow SFX are present in-scene, with the following paths. 
	if(alt_label_texts.size() > 0):
		var alt_title_screen_index = randi() % alt_label_texts.size()
		
		var mario_sprite = get_node("VBoxContainer/IdleMario")
		mario_sprite.texture = ResourceLoader.load(alt_sprite_paths[alt_title_screen_index])
		var mario_label = get_node("VBoxContainer/Mario")
		mario_label.text = alt_label_texts[alt_title_screen_index]
		mario_label.bbcode_text = "\n[center][wave amp=100 freq=2][rainbow freq=0.5 sat=1 val=1]" + mario_label.text + "[/rainbow]"
		var on_click_sfx = get_node("VBoxContainer/IdleMario/Meow")
		on_click_sfx.stream = ResourceLoader.load(alt_sound_effect_paths[alt_title_screen_index])
	else:
		print("No alt title screens found")

#func import_trim(path: String):
	
