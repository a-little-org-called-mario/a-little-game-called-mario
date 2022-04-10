#this whole thing can be cleaned up and made better

extends CanvasLayer

onready var label_back = get_node("PauseMenu/MainMenu/BackLabel");
onready var label_gfx = get_node("PauseMenu/MainMenu/GFXLabel");
onready var label_sfx = get_node("PauseMenu/MainMenu/SFXLabel");

onready var label_gfxback = get_node("PauseMenu/GFXMenu/BackLabel");
onready var label_camlean = get_node("PauseMenu/GFXMenu/CamLeanLabel");
onready var label_shake = get_node("PauseMenu/GFXMenu/ShakeLabel");
onready var label_crt = get_node("PauseMenu/GFXMenu/CRTLabel");

const CameraLeanAmount = preload("res://scripts/CameraLeanAmount.gd");

enum PAUSE_MENU {MAIN,GFX,SFX};
var current_menu : int = PAUSE_MENU.MAIN;
var element_selected : int = 0;

func _ready() -> void:
	$PauseMenu/MainMenu.show();
	$PauseMenu/GFXMenu.hide();
	$PauseMenu/SFXMenu.hide();
	$PauseMenu.hide();
	EventBus.connect("game_paused",self,"_on_pause_toggle");
	
func _process(_delta:float) -> void:
	if Input.is_action_just_pressed("pause"):
		EventBus.emit_signal("game_paused",!get_tree().paused);
	else:
		if $PauseMenu.visible:
			if Input.is_action_just_pressed("ui_down"):
				element_selected=(element_selected+1)%get_element_count();
				set_active_element_style();
			elif Input.is_action_just_pressed("ui_up"):
				if 0 < element_selected:
					element_selected=element_selected-1;
				else:
					element_selected=get_element_count()-1;
				set_active_element_style();
			elif Input.is_action_just_pressed("ui_left"):
				#camera lean selection
				if 1 == element_selected && PAUSE_MENU.GFX == current_menu:
					cam_lean_select(-1);
				#screen shake selection
				if 2== element_selected && PAUSE_MENU.GFX == current_menu:
					Settings.screen_shake=!Settings.screen_shake;
					label_shake.text="\nSCREEN SHAKE: " + ("ON" if Settings.screen_shake else "OFF");
					set_active_element_style();
				#crt filter selection
				elif 3 == element_selected && PAUSE_MENU.GFX == current_menu:
					Settings.crt_filter=!Settings.crt_filter;
					label_crt.text="\nCRT FILTER: " + ("ON" if Settings.crt_filter else "OFF");
					set_active_element_style();
					EventBus.emit_signal("crt_filter_toggle",Settings.crt_filter);
			elif Input.is_action_just_pressed("ui_right"):
				#camera lean selection
				if 1 == element_selected && PAUSE_MENU.GFX == current_menu:
					cam_lean_select(1);
				#screen shake selection
				if 2== element_selected && PAUSE_MENU.GFX == current_menu:
					Settings.screen_shake=!Settings.screen_shake;
					label_shake.text="\nSCREEN SHAKE: " + ("ON" if Settings.screen_shake else "OFF");
					set_active_element_style();
				#crt filter selection
				elif 3 == element_selected && PAUSE_MENU.GFX == current_menu:
					Settings.crt_filter=!Settings.crt_filter;
					label_crt.text="\nCRT FILTER: " + ("ON" if Settings.crt_filter else "OFF");
					set_active_element_style();
					EventBus.emit_signal("crt_filter_toggle",Settings.crt_filter);
			elif Input.is_action_just_pressed("ui_accept"):
				match current_menu:
					PAUSE_MENU.MAIN: main_menu_accept();
					PAUSE_MENU.GFX: gfx_menu_accept();
					PAUSE_MENU.SFX:
						pass;

# data: whether or not we want the game to be paused
func _on_pause_toggle (data:bool) -> void:
	if data:
		$PauseMenu.show();
		set_active_element_style();
	else:
		element_selected=0;
		current_menu=0;
		$PauseMenu/MainMenu.show();
		$PauseMenu/GFXMenu.hide();
		$PauseMenu.hide();
	get_tree().paused=data;

#note [jam] : this is a dumb way of getting the total list of menu items - oh well
func get_element_count () -> int:
	match current_menu:
		PAUSE_MENU.MAIN: return 2; #NOTE [jam] - make this 3 when adding sfx options
		PAUSE_MENU.GFX: return 4;
		PAUSE_MENU.SFX: return 4;
	return 1;

func set_active_element_style () -> void:
	if PAUSE_MENU.MAIN == current_menu:
		label_back.bbcode_text=label_back.text;
		label_gfx.bbcode_text=label_gfx.text;
		label_sfx.bbcode_text=label_sfx.text;

		match element_selected:
			0: label_back.bbcode_text="[color=yellow][wave amp=25 freq=1]"+str(label_back.text)+"[/wave][/color]";
			1: label_gfx.bbcode_text="[color=yellow][wave amp=25 freq=1]"+str(label_gfx.text)+"[/wave][/color]";
			2: label_sfx.bbcode_text="[color=yellow][wave amp=25 freq=1]"+str(label_sfx.text)+"[/wave][/color]";
	elif PAUSE_MENU.GFX == current_menu:
		label_gfxback.bbcode_text=label_gfxback.text;
		label_camlean.bbcode_text=label_camlean.text;
		label_shake.bbcode_text=label_shake.text;
		label_crt.bbcode_text=label_crt.text;

		match element_selected:
			0: label_gfxback.bbcode_text="[color=yellow][wave amp=25 freq=1]"+str(label_gfxback.text)+"[/wave][/color]";
			1: label_camlean.bbcode_text="[color=yellow][wave amp=25 freq=1]"+str(label_camlean.text)+"[/wave][/color]";
			2: label_shake.bbcode_text="[color=yellow][wave amp=25 freq=1]"+str(label_shake.text)+"[/wave][/color]";
			3: label_crt.bbcode_text="[color=yellow][wave amp=25 freq=1]"+str(label_crt.text)+"[/wave][/color]";

func main_menu_accept () -> void:
	match element_selected:
		0:
			EventBus.emit_signal("game_paused",false);
		1:
			$PauseMenu/MainMenu.hide();
			$PauseMenu/GFXMenu.show();
			current_menu=PAUSE_MENU.GFX;
			element_selected=0;
			set_active_element_style();
		2:
			pass;
			#$PauseMenu/MainMenu.hide();
			#$PauseMenu/SFXMenu.show();
			#current_menu=PAUSE_MENU.SFX;
			#element_selected=0;
			#set_active_element_style();

func gfx_menu_accept () -> void:
	match element_selected:
		0:
			$PauseMenu/GFXMenu.hide();
			$PauseMenu/MainMenu.show();
			current_menu=PAUSE_MENU.MAIN;
			element_selected=0;
			set_active_element_style();
			pass;
		1:
			cam_lean_select(1);
		3:
			Settings.crt_filter=!Settings.crt_filter;
			label_crt.text="\nCRT FILTER: " + ("ON" if Settings.crt_filter else "OFF");
			set_active_element_style();
			EventBus.emit_signal("crt_filter_toggle",Settings.crt_filter);
		2:
			Settings.screen_shake=!Settings.screen_shake;
			label_shake.text="\nSCREEN SHAKE: " + ("ON" if Settings.screen_shake else "OFF");
			set_active_element_style();

func cam_lean_select (delta: int) -> void:
	if 1 == delta:
		Settings.camera_lean=(Settings.camera_lean+1)%3;
	else:
		if 0 < Settings.camera_lean:
			Settings.camera_lean=Settings.camera_lean-1;
		else:
			Settings.camera_lean=CameraLeanAmount.MAX;

	label_camlean.text="\nCAMERA LEAN: <  "+ ("OFF" if CameraLeanAmount.OFF == Settings.camera_lean else "MIN" if CameraLeanAmount.MIN == Settings.camera_lean else "MAX") +"  >"
	set_active_element_style();
	pass;
