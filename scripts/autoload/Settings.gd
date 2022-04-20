extends Node

const CameraLeanAmount = preload("res://scripts/CameraLeanAmount.gd")

# settings file name
var settings_name = "user://settings.mario"
var settings_loaded: bool = false

# graphics settings
var camera_lean: int = -1
var screen_shake: bool = false
var crt_filter: bool = false

# sfx settings
var volume_game: int = -1
var volume_music: int = -1
var volume_sfx: int = -1
var volume_voice: int = -1

func save_data():
	# create dictionary of settings data
	var settings_values = {
		"gfx_camera_lean": camera_lean,
		"gfx_screen_shake": screen_shake,
		"gfx_crt_filter": crt_filter,
		"sfx_volume_game": volume_game,
		"sfx_volume_music": volume_music,
		"sfx_volume_sfx": volume_sfx,
		"sfx_volume_voice": volume_voice,
	}

	# access settings.mario and write settings to it
	var settings_file = File.new()
	settings_file.open(settings_name, File.WRITE)
	settings_file.store_line(to_json(settings_values))
	settings_file.close()


func load_data():
	var settings_file = File.new()

	# there is no settings.mario :(
	if not settings_file.file_exists(settings_name) or settings_file.open(settings_name, File.READ) != OK:
		# set settings to default values
		set_to_default()
	# access settings.mario and read settings
	else:
		while settings_file.get_position() < settings_file.get_len():
			var settings_values = parse_json(settings_file.get_line())
			for i in settings_values.keys():
				match i:
					"gfx_camera_lean":
						camera_lean = int(settings_values[i])
					"gfx_screen_shake":
						screen_shake = bool(settings_values[i])
					"gfx_crt_filter":
						crt_filter = bool(settings_values[i])
					"sfx_volume_game":
						volume_game = int(settings_values[i])
					"sfx_volume_music":
						volume_music = int(settings_values[i])
					"sfx_volume_sfx":
						volume_sfx = int(settings_values[i])
					"sfx_volume_voice":
						volume_voice = int(settings_values[i])
		settings_file.close()
		set_to_default()	# catch any settings that were added since the last time cookie was saved
		settings_loaded = true

	# emit any relevant signals
	EventBus.emit_signal("crt_filter_toggle", crt_filter)
	for bus in [ "Master", "music", "sfx", "voice" ]:
		EventBus.emit_signal("volume_changed", bus);

func set_to_default():
	if camera_lean == -1: camera_lean = CameraLeanAmount.OFF
	if volume_game == -1: volume_game = 10
	if volume_music == -1: volume_music = 10
	if volume_sfx == -1: volume_sfx = 10
	if volume_voice == -1: volume_voice = 10
