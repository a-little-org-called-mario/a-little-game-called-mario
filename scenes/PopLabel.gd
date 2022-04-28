extends Control
class_name PopLabel

const DISTANCE := 100.0
var default_font_path := "res://scenes/ui/Themes/Default/DefaultFont.tres"


func _ready():
	if !has_node("Label") or !has_node("Tween"):
		var label := Label.new()
		add_child(label, true)
		label.rect_position.x = -1
		label.rect_size = Vector2(2, 16)
		label.grow_horizontal = Control.GROW_DIRECTION_BOTH
		if ResourceLoader.exists(default_font_path):
			label.add_font_override("font", load(default_font_path))

		var tween := Tween.new()
		add_child(tween, true)


func pop(
	text: String, speed: float = 1.0, duration: float = 1.0, scale := 1.0, color := Color.white
):
	if !has_node("Label") or !has_node("Tween"):
		return
	$Label.text = text
	rect_scale *= scale
	modulate = color

	$Tween.interpolate_property(
		$Label,
		"rect_position",
		null,
		Vector2($Label.rect_position.x, -DISTANCE * speed),
		duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		$Label, "modulate", null, Color.transparent, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	$Tween.start()
	yield($Tween, "tween_completed")
	queue_free()


func change_font(new_font: Font):
	$Label.add_font_override("font", new_font)
