extends Area2D

signal talked_to

export var title : String
export var dialog : String

func _ready() -> void:
	$TalkToLabel.text %= title
	$TalkToLabel.hide()


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("fire") and get_overlapping_bodies():
		emit_signal("talked_to")


func set_sprite(to):
	$Sprite.texture = to


func get_portrait() -> Texture:
	return $Sprite.texture


func _on_body_entered(_body: Node) -> void:
	$TalkToLabel.show()


func _on_body_exited(_body: Node) -> void:
	$TalkToLabel.hide()
