extends Node

const CameraLeanAmount = preload("res://scripts/CameraLeanAmount.gd")

# settings file name
var settings_name = "user://settings.mario";
var settings_loaded : bool = false;

# graphics settings
var camera_lean : int;
var screen_shake : bool;
var crt_filter : bool;

# sfx settings
var volume_game : int;
var volume_music : int;
var volume_sfx : int;

func save_data ():
	# create dictionary of settings data
	var settings_values = {
								"gfx_camera_lean":      camera_lean,
								"gfx_screen_shake":     screen_shake,
								"gfx_crt_filter":       crt_filter,

								"sfx_volume_game":      volume_game,
								"sfx_volume_music":     volume_music,
								"sfx_volume_sfx":       volume_sfx
						  };

	# access settings.mario and write settings to it
	var settings_file = File.new();
	settings_file.open(settings_name, File.WRITE);
	settings_file.store_line(to_json(settings_values));
	print(">>>>" + to_json(settings_values));
	settings_file.close();

func load_data ():
	var settings_file = File.new();

	# there is no settings.mario :(
	if not settings_file.file_exists(settings_name):
		# set settings to default values
		camera_lean=        CameraLeanAmount.MAX;
		screen_shake=       true;
		crt_filter=         true;

		volume_game=        10;
		volume_music=       10;
		volume_sfx=         10;
		return;

	# access settings.mario and read settings
	settings_file.open(settings_name, File.READ);
	while settings_file.get_position() < settings_file.get_len():
		var settings_values = parse_json(settings_file.get_line());
		for i in settings_values.keys():
			match i:
				"gfx_camera_lean":      camera_lean=    int(settings_values[i]);
				"gfx_screen_shake":     screen_shake=   bool(settings_values[i]);
				"gfx_crt_filter":       crt_filter=     bool(settings_values[i]);
				"sfx_volume_game":      volume_game=    int(settings_values[i]);
				"sfx_volume_music":     volume_music=   int(settings_values[i]);
				"sfx_volume_sfx":       volume_sfx=     int(settings_values[i]);
	settings_file.close();
	settings_loaded = true;

	# emit any relevant signals
	EventBus.emit_signal("crt_filter_toggle",crt_filter);
	EventBus.emit_signal("volume_changed","game");
	EventBus.emit_signal("volume_changed","music");
	EventBus.emit_signal("volume_changed","sfx");
