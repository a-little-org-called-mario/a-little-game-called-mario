extends Timer


export(NodePath) onready var fire_flower_refill = get_node(fire_flower_refill) as Timer


var inventory: PlayerInventory = preload("res://scripts/resources/PlayerInventory.tres")


func _ready():
	EventBus.connect("shot", self, "_on_shot")


func _on_shot():
	fire_flower_refill.stop()
	self.start()


func _on_RestTimer_timeout():
	if inventory.has_flower:
		fire_flower_refill.start()


func _on_FireFlowerRefillTimer_timeout():
	if inventory.flower_amount < inventory.MAX_FLOWER:
		EventBus.emit_signal("fire_flower_refilled", 1)
	else:
		fire_flower_refill.stop()
