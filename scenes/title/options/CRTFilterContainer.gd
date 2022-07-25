extends HBoxContainer

onready var texture_rect: TextureRect = $TextureRect
onready var value_check_box: CheckBox = $ValueCheckBox
var check_box_focused = false

func _ready() -> void:
	value_check_box.connect("focus_entered", self, "_on_focus_entered")
	value_check_box.connect("focus_exited", self, "_on_focus_exited")
	value_check_box.connect("mouse_entered", self, "_on_focus_entered")
	value_check_box.connect("mouse_exited", self, "_on_focus_exited")
	hide_icon()
	update_value_check_box_pressed_state(Settings.crt_filter)

func update_value_check_box_pressed_state(state):
	value_check_box.pressed = state
	value_check_box.text = "ON" if state else "OFF"
	Settings.crt_filter = state

func _input(_event: InputEvent) -> void:
	if check_box_focused:
		if Input.is_action_just_pressed("ui_left"):
			update_value_check_box_pressed_state(false)
		elif Input.is_action_just_pressed("ui_right"):
			update_value_check_box_pressed_state(true)
			
func show_icon():
	texture_rect.modulate.a = 1

func hide_icon():
	texture_rect.modulate.a = 0
	
func _on_focus_entered():
	check_box_focused = true
	show_icon()
	
func _on_focus_exited():
	check_box_focused = false
	hide_icon()
	
func _on_ValueCheckBox_pressed() -> void:
	update_value_check_box_pressed_state(value_check_box.pressed)
	Settings.crt_filter = value_check_box.pressed
