extends ColorRect

func _ready() -> void:
	EventBus.connect("crt_filter_toggle", self, "_on_crt_toggle")


func _on_crt_toggle(on: bool) -> void:
	visible = on
