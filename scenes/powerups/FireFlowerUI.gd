extends Control

export (NodePath) onready var label = get_node(label) as Label

var inventory: PlayerInventory = preload("res://scripts/resources/PlayerInventory.tres")


func _ready():
	label.text = str(inventory.flower_amount)
	EventBus.connect("fire_flower_collected", self, "_on_powerup_collected")
	EventBus.connect("fire_flower_ended", self, "hide")
	EventBus.connect("shot", self, "_on_shot")


func _on_powerup_collected(data := {}) -> void:
	label.text = str(data.get("amount", 100))
	self.show()


func _on_shot() -> void:
	if inventory.has_flower:
		label.text = str(inventory.flower_amount)
