extends Area2D


export var damage = 1

signal dealt_damage


func _ready():
	self.connect("body_entered", self, "_body_entered")


func _body_entered(body):
	emit_signal("dealt_damage")
	# HeartInventoryHandle.change_hearts_on(body, -damage)
	# This should be changed at some point.
	# It currently does not function properly when dealing
	# more than 1 damage.
	for i in range(damage):
		HeartInventoryHandle.change_hearts_on(body, -1)

