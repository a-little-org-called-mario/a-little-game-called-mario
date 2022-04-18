extends Control


func _ready() -> void:
	EventBus.connect("ui_visibility_changed", self, "_on_ui_visibility_changed")


func _on_ui_visibility_changed(visible: bool) -> void:
	self.visible = visible
