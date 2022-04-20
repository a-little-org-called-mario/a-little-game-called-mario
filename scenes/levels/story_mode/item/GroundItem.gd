tool
extends Area2D

export var item: Resource setget _set_item

var _pickup_text := "Pick up %s"

onready var _pickup_label: Label = $PickupLabel
onready var _sprite: Sprite = $Sprite

func _set_item(to: StoryItem):
	item = to
	$PickupLabel.text = tr(_pickup_text) % to.name
	$Sprite.texture = to.texture
