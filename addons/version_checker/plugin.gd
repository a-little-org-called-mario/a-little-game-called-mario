tool
extends EditorPlugin

var popup_scene : PackedScene = preload("res://addons/version_checker/version_checker_popup.tscn")


func _enter_tree() -> void:
	var version_info : Dictionary = Engine.get_version_info()

	if version_info.major == 3 and version_info.minor >= 4:
		return

	var popup : AcceptDialog = popup_scene.instance()
	popup.connect("confirmed", popup, "hide")
	popup.connect("popup_hide", popup, "queue_free")

	popup.dialog_text = popup.dialog_text.replace("XXX", version_info.string)

	get_editor_interface().get_base_control().add_child(popup)

	popup.popup_centered_clamped(Vector2(340, 180))
