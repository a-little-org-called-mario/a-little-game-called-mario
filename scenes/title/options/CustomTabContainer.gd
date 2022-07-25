extends VBoxContainer

onready var audio_tab: Control = $Tabs/AudioTab
onready var graphics_tab: Control = $Tabs/GraphicsTab
onready var audio_settings: VBoxContainer = $Panel/AudioSettings
onready var graphics_settings: Control = $Panel/GraphicsSettings


func _ready() -> void:
	audio_tab.grab_focus()
	audio_tab.selected()
	graphics_settings.visible = false

#	graphics_tab.grab_focus()
#	graphics_tab.selected()
#	audio_settings.visible = false


func select_audio_tab():
	audio_tab.selected()
	graphics_tab.deselected()
	audio_settings.visible = true
	graphics_settings.visible = false

func select_graphics_tab():
	graphics_tab.selected()
	audio_tab.deselected()
	audio_settings.visible = false
	graphics_settings.visible = true


func _on_AudioTab_focus_entered() -> void:
	select_audio_tab()

func _on_GraphicsTab_focus_entered() -> void:
	select_graphics_tab()
