extends OptionContainer 

func _ready() -> void:
	option_slider.tick_count = 3
	option_slider.ticks_on_borders = true
	option_slider.max_value = 2
	option_slider.value = Settings.camera_lean
	if Settings.camera_lean == -1:
		option_slider.value = 0
	option_slider.connect("value_changed", self, "_on_value_changed")
	
	value_label.text = str(value_label_mapping.get(Settings.camera_lean))

func _on_value_changed(value):
	Settings.camera_lean = int(value)
