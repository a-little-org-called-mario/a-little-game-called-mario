tool
extends Area2D

signal picked_up

export var item: Resource setget _set_item

var _pickup_text := "[Q] Pick up %s"

func _ready() -> void:
	$PickupLabel.visible = Engine.is_editor_hint()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and get_overlapping_bodies():
		emit_signal("picked_up")


func _set_item(to: StoryItem):
	item = to
	$PickupLabel.text = tr(_pickup_text) % to.name
	$Sprite.texture = to.texture


func _on_body_entered(_body):
	$PickupLabel.show()


func _on_body_exited(_body: Node) -> void:
	$PickupLabel.hide()
