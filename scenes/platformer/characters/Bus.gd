extends Node


var inventory = preload("res://scripts/resources/PlayerInventory.tres")
onready var player : Player = owner
onready var sprite : Sprite = player.get_node("BusSprite")
onready var collision : CollisionShape2D = player.get_node("BusCollision")


func _ready() -> void:
	EventBus.connect("bus_collected", self, "_on_bus_collected")
	if inventory.has_bus:
		_activate_bus()
	else:
		set_process(false)


func _process(_delta: float) -> void:
	sprite.flip_h = !player.sprite.flip_h
	if inventory.has_bus:
		player.powerupspeed = 4
		player.powerupaccel = 2
	else:
		player.powerupspeed = 1
		player.powerupaccel = 1


func _on_bus_collected(data: Dictionary) -> void:
	if data.has("collected"):
		inventory.has_bus = data["collected"]
		_activate_bus()


func _activate_bus() -> void:
	sprite.visible = true
	collision.set_deferred("disabled", false)
	call_deferred("_update_player")
	set_process(true)


func _update_player() -> void:
	player.sprite.visible = false
	player.get_node("CollisionShape2D").set_deferred("disabled", true)
	var trail: Line2D = player.get_node_or_null("Trail")
	if trail != null:
		trail.height = 15
