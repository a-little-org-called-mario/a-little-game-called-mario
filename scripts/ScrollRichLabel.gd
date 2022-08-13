"""
This class exist as a workaround for some strange bug with scrollbar:
max_value is different from actual clamped max value
https://github.com/godotengine/godot/issues/62043
"""
extends RichTextLabel
class_name ScrollRichLabel

export(float) var scroll_value: float = 0.0 setget set_scroll_value
export(float) var percent_scroll: float = 0.0 setget set_percent_scroll

onready var scroll_bar: VScrollBar = get_v_scroll()
onready var real_max_value: int = get_content_height()


func _ready():
	scroll_bar.step = 0.1


func _process(_delta: float) -> void:
	update_max_scroll_value()


func set_percent_scroll(percent: float) -> void:
	self.scroll_value = real_max_value * percent


func set_scroll_value(value: float) -> void:
	scroll_value = clamp(value, 0, real_max_value)
	scroll_bar.value = scroll_value


func update_max_scroll_value() -> void:
	var initial_value: float = scroll_bar.value
	scroll_bar.value = scroll_bar.max_value
	self.real_max_value = scroll_bar.value
	scroll_bar.value = initial_value
