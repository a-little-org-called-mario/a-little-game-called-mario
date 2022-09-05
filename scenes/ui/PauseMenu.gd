extends CanvasLayer

## NOTE (jam):  Right now each submenu can fit comfortably on a single screen, so it's not a pressing concern,
#               but it might be wise to rework the submenu scene such that they're situated in their own VScrollContainers

const CameraLeanAmount = preload("res://scripts/CameraLeanAmount.gd")

### Basic pause menu state variables
enum SUBMENU {
	MAIN = 0,
	GFX = 1,
	SFX = 2,
}
var current_menu: int = SUBMENU.MAIN  # the menu we're currently in
var menu_count: int = 3  # the total number of menus we can access
var selected: int = 0  # the menu item we're currently selecting

### Godot nodes
# all of our submenus, ordered according to SUBMENU
onready var menus = [
	$PauseMenu/MainMenu,
	$PauseMenu/GFXMenu,
	$PauseMenu/SFXMenu,
]
# all of our submenu items, ordered according to SUBMENU
onready var labels = [
	# all main menu items, ordered vertically
	[
		get_node("PauseMenu/MainMenu/BackLabel"),
		get_node("PauseMenu/MainMenu/GFXLabel"),
		get_node("PauseMenu/MainMenu/SFXLabel"),
		get_node("PauseMenu/MainMenu/RestartLabel"),
		get_node("PauseMenu/MainMenu/TitleLabel"),
	],
	# all gfx menu items, ordered vertically
	[
		get_node("PauseMenu/GFXMenu/BackLabel"),
		get_node("PauseMenu/GFXMenu/CamLeanLabel"),
		get_node("PauseMenu/GFXMenu/ShakeLabel"),
		get_node("PauseMenu/GFXMenu/CRTLabel"),
	],
	# all sfx menu items, ordered vertically
	[
		get_node("PauseMenu/SFXMenu/BackLabel"),
		get_node("PauseMenu/SFXMenu/GameVolLabel"),
		get_node("PauseMenu/SFXMenu/MusicVolLabel"),
		get_node("PauseMenu/SFXMenu/SFXVolLabel"),
		get_node("PauseMenu/SFXMenu/VoiceVolLabel"),
	],
]


## Node ready override.
func _ready():
	# connect this node to the game_paused signal
	EventBus.connect("game_paused", self, "pause_toggle")

	# prepare default submenu and hide all ui elements
	selected = 0
	current_menu = 0
	menus[0].show()
	menus[1].hide()
	menus[2].hide()
	$PauseMenu.hide()

	#prepare labels
	if Settings.settings_loaded:
		prepare_labels()


## Node process override.
#  @dt: the amount of time, in seconds, since last called. Superfluous here - unnecessary even! Vestigial, perhaps
# NOTE (jam):   This is a bit dirty still - in the event that someone changes the order of menu items, a lot of these
#               switch statements are going to need to be rewritten, since it's all hardcoded based on index value
func _process(_delta: float):
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		EventBus.emit_signal("game_paused", true)

	elif $PauseMenu.visible:
		var label: RichTextLabel = labels[current_menu][selected]
		if Input.is_action_just_pressed("ui_down"):
			# move selected item down one and style accordingly
			selected = (1 + selected) % labels[current_menu].size()
			set_item_style()
		elif Input.is_action_just_pressed("ui_up"):
			# move selected item up one and style accordingly
			selected = selected - 1 if 0 < selected else labels[current_menu].size() - 1
			set_item_style()
		elif Input.is_action_just_pressed("ui_left"):
			match current_menu:
				SUBMENU.MAIN:
					pass
				SUBMENU.GFX:
					match selected:
						0:
							pass
						1:
							cam_lean_select(-1, label)
						2:
							screen_shake_toggle(label)
						3:
							crt_filter_toggle(label)
				SUBMENU.SFX:
					if 0 < selected:
						volume_select(-1, label)
		elif Input.is_action_just_pressed("ui_right"):
			match current_menu:
				SUBMENU.MAIN:
					pass
				SUBMENU.GFX:
					match selected:
						0:
							pass
						1:
							cam_lean_select(1, label)
						2:
							screen_shake_toggle(label)
						3:
							crt_filter_toggle(label)
				SUBMENU.SFX:
					if 0 < selected:
						volume_select(1, label)
		elif Input.is_action_just_pressed("ui_accept"):
			match current_menu:
				SUBMENU.MAIN:
					match selected:
						0:
							EventBus.emit_signal("game_paused", false)
						1:
							go_to_menu(SUBMENU.GFX)
						2:
							go_to_menu(SUBMENU.SFX)
						3:
							EventBus.emit_signal("game_paused", false)
							EventBus.emit_signal("restart_level")
						4:
							EventBus.emit_signal("game_paused", false)
							get_tree().change_scene("res://scenes/title/TitleScreen.tscn")
				SUBMENU.GFX:
					match selected:
						0:
							go_to_menu(SUBMENU.MAIN)
						1:
							cam_lean_select(1, label)
						2:
							screen_shake_toggle(label)
						3:
							crt_filter_toggle(label)
				SUBMENU.SFX:
					if 0 == selected:
						go_to_menu(SUBMENU.MAIN)
					else:
						volume_select(1, label)
		elif Input.is_action_just_pressed("pause"):
			match current_menu:
				SUBMENU.MAIN:
					EventBus.emit_signal("game_paused", false)
				_:
					go_to_menu(SUBMENU.MAIN)


## Callback for the signal "game_paused".
#  @data: the desired pause state for the game
#  @save: whether or not this should save settings on un-pause
func pause_toggle(data: bool):
	if data:
		# if pausing, show the pause menu and set up selection styling
		$PauseMenu.show()
		set_item_style()

		# make sure that labels are up to date
		if Settings.settings_loaded:
			prepare_labels()
	else:
		# if un-pausing, reset the pause menu and hide it
		selected = 0
		current_menu = 0
		menus[0].show()
		menus[1].hide()
		menus[2].hide()
		$PauseMenu.hide()

		# save all settings to file / cookie
		Settings.save_data()

	# pause ... or un-pause! the choice is yours
	get_tree().paused = data


## Updates and restyles each submenu item. Should be called whenever the currently selected item is changed.
func set_item_style():
	# iterate over each available menu item
	for item in range(0, labels[current_menu].size()):
		# if this item is the currently selected item, put a wave on it
		if item == selected:
			wavify(labels[current_menu][item])
			continue
		# if not, make it normal
		labels[current_menu][item].bbcode_text = labels[current_menu][item].text


## Sets a label's BBCode text to a yellow, wavy version of its normal text. Really only meant to be used in set_item_style.
#  @item: the RichTextLabel we want to make C O O L
#  @amp:  the amplitude of the wave effect, default=25
#  @freq: the frequency of the wave effect, default=1
func wavify(item: RichTextLabel, amp: int = 25, freq: int = 1):
	item.bbcode_text = (
		"[color=yellow][wave amp="
		+ str(amp)
		+ " freq="
		+ str(freq)
		+ "]"
		+ str(item.text)
		+ "[/wave][/color]"
	)


## Sets the currently active menu. Should be called whenever the desired menu is changed.
#  @menu: the menu we want to switch to (should be assigned from the SUBMENU enum)
func go_to_menu(menu: int):
	# make sure the passed menu is a valid menu
	if 0 > menu or menu_count <= menu:
		return

	# set current menu to the desired menu and reset selected item
	current_menu = menu
	selected = 0

	# hide all but desired menu
	for sub in range(0, menus.size()):
		if sub == menu:
			menus[sub].show()
			continue
		else:
			menus[sub].hide()

	# reapply... the wave
	set_item_style()


## Updates the camera lean value in the global Settings.
#  @delta: whether or not to move the faux-slider right (1) or left (-1)
#  @label: the label that needs to be updated with the new value
func cam_lean_select(delta: int, label: RichTextLabel):
	# modify settings value depending on which direction we're toggling
	if 1 == delta:
		Settings.camera_lean = (1 + Settings.camera_lean) % 3
	else:
		Settings.camera_lean = (
			Settings.camera_lean - 1
			if 0 < Settings.camera_lean
			else CameraLeanAmount.MAX
		)

	# update label innards with the new settings value - dirty string manip inbound
	label.text = (
		"\nCAMERA LEAN: <  "
		+ (
			"OFF"
			if CameraLeanAmount.OFF == Settings.camera_lean
			else "MIN" if CameraLeanAmount.MIN == Settings.camera_lean else "MAX"
		)
		+ "  >"
	)

	# reapply the wave
	set_item_style()


## Updates the screen shake value in the global Settings.
#  @label: the label that needs to be updated with the new value
func screen_shake_toggle(label: RichTextLabel):
	Settings.screen_shake = !Settings.screen_shake  # modify settings value
	label.text = "\nSCREEN SHAKE: " + ("ON" if Settings.screen_shake else "OFF")  # update label innards - less dirty string manip
	set_item_style()  # reappy the wave


## Updates the CRT filter value in the global Settings.
#  @label: the label that needs to be updated with the new value
func crt_filter_toggle(label: RichTextLabel):
	Settings.crt_filter = !Settings.crt_filter  # modify settings value
	label.text = "\nCRT FILTER: " + ("ON" if Settings.crt_filter else "OFF")  # update label innards - less dirty string manip
	set_item_style()  # reapply the wave
	EventBus.emit_signal("crt_filter_toggle", Settings.crt_filter)  # emit signal, so that Main.gd can swap shaders


## Updates the volume value for the currently selected bus in the global Settings.
#  @delta: whether or not to move the faux-slider right (1) or left (-1)
#  @label: the label that needs to be updated with the new value
# NOTE (jam):   If we add more audio buses that need to be managed separately (i.e., a voice acting bus with its own volume),
#               the hacky ternary statement in this signal emission AS WELL AS the match statement in Main.gd's _on_volume_change
#               will both need to be updated
func volume_select(delta: int, label: RichTextLabel):
	# NOTE (jam):   I'm very sorry for the hacky ternary string manipulation

	# update the appropriate volume value and label text
	match selected:
		1:
			Settings.volume_game = int(clamp(Settings.volume_game + delta, 0, 10))
			label.text = (
				"\nGAME VOLUME: "  # title
				+ ("<" if 0 < Settings.volume_game else " ")  # only show the < symbol if we can still lower the volume
				+ "  "
				+ (" " if 10 > Settings.volume_game else "")  # space the number properly, depending on if single-/double-digit
				+ str(Settings.volume_game)
				+ "  "  # convert value to string and concat
				+ (">" if 10 > Settings.volume_game else " ")
				+ "\n"
			)  # only show the > symbol if we can still raise the volume
		2:
			Settings.volume_music = int(clamp(Settings.volume_music + delta, 0, 10))
			label.text = (
				"\nMUSIC VOLUME: "
				+ ("<" if 0 < Settings.volume_music else " ")
				+ "  "
				+ (" " if 10 > Settings.volume_music else "")
				+ str(Settings.volume_music)
				+ "  "
				+ (">" if 10 > Settings.volume_music else " ")
				+ "\n"
			)
		3:
			Settings.volume_sfx = int(clamp(Settings.volume_sfx + delta, 0, 10))
			label.text = (
				"\nSFX VOLUME: "
				+ ("<" if 0 < Settings.volume_sfx else " ")
				+ "  "
				+ (" " if 10 > Settings.volume_sfx else "")
				+ str(Settings.volume_sfx)
				+ "  "
				+ (">" if 10 > Settings.volume_sfx else " ")
				+ "\n"
			)
			$"PauseMenu/SFXMenu/SFX Player".play()
		4:
			Settings.volume_voice = int(clamp(Settings.volume_voice + delta, 0, 10))
			label.text = (
				"\nVOICE VOLUME: "
				+ ("<" if 0 < Settings.volume_voice else " ")
				+ "  "
				+ (" " if 10 > Settings.volume_voice else "")
				+ str(Settings.volume_voice)
				+ "  "
				+ (">" if 10 > Settings.volume_voice else " ")
				+ "\n"
			)
			$"PauseMenu/SFXMenu/Voice Player".play()

	# reapply the wave
	set_item_style()

	# emit volume change signal, so that Main.gd can modify buses
	var bus_names = [ "Master", "music", "sfx", "voice" ]
	EventBus.emit_signal(
		"volume_changed", bus_names[selected - 1]
	)


## Prepares all the labels with the loaded Settings. Should ONLY be called in _ready().
func prepare_labels():
	var label: RichTextLabel
	for gfx in range(1, labels[SUBMENU.GFX].size()):
		label = labels[SUBMENU.GFX][gfx]
		match gfx:
			1:
				label.text = (
					"\nCAMERA LEAN: <  "
					+ (
						"OFF"
						if CameraLeanAmount.OFF == Settings.camera_lean
						else "MIN" if CameraLeanAmount.MIN == Settings.camera_lean else "MAX"
					)
					+ "  >"
				)
			2:
				label.text = "\nSCREEN SHAKE: " + ("ON" if Settings.screen_shake else "OFF")
			3:
				label.text = "\nCRT FILTER: " + ("ON" if Settings.crt_filter else "OFF")

	for sfx in range(1, labels[SUBMENU.SFX].size()):
		label = labels[SUBMENU.SFX][sfx]
		match sfx:
			1:
				label.text = (
					"\nGAME VOLUME: "
					+ ("<" if 0 < Settings.volume_game else " ")
					+ "  "
					+ (" " if 10 > Settings.volume_game else "")
					+ str(Settings.volume_game)
					+ "  "
					+ (">" if 10 > Settings.volume_game else " ")
					+ "\n"
				)
			2:
				label.text = (
					"\nMUSIC VOLUME: "
					+ ("<" if 0 < Settings.volume_music else " ")
					+ "  "
					+ (" " if 10 > Settings.volume_music else "")
					+ str(Settings.volume_music)
					+ "  "
					+ (">" if 10 > Settings.volume_music else " ")
					+ "\n"
				)
			3:
				label.text = (
					"\nSFX VOLUME: "
					+ ("<" if 0 < Settings.volume_sfx else " ")
					+ "  "
					+ (" " if 10 > Settings.volume_sfx else "")
					+ str(Settings.volume_sfx)
					+ "  "
					+ (">" if 10 > Settings.volume_sfx else " ")
					+ "\n"
				)
			4:
				label.text = (
					"\nVOICE VOLUME: "
					+ ("<" if 0 < Settings.volume_voice else " ")
					+ "  "
					+ (" " if 10 > Settings.volume_voice else "")
					+ str(Settings.volume_voice)
					+ "  "
					+ (">" if 10 > Settings.volume_voice else " ")
					+ "\n"
				)
			
	pass
