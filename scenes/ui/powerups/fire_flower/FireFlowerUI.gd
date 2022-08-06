extends Control

export (NodePath) onready var label = get_node(label) as Label

var inventory: PlayerInventory = preload("res://scripts/resources/PlayerInventory.tres")


func _ready():
	EventBus.connect("fire_flower_collected", self, "_on_powerup_collected")
	EventBus.connect("fire_flower_changed", self, "_on_fire_flower_changed")


func _on_powerup_collected(data := {}) -> void:
	self.show()


func _on_fire_flower_changed(value) -> void:
	label.text = str(value)
