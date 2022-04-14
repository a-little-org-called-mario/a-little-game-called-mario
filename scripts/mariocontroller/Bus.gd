extends Node


onready var player : Player = owner
onready var sprite : Sprite = player.get_node("BusSprite")
onready var collision : CollisionShape2D = player.get_node("BusCollision")

func _ready() -> void:
	EventBus.connect("bus_collected", self, "_on_bus_collected")
	if player.inventory.has_bus:
		_activate_bus()
	else:
		set_process(false)


func _process(_delta: float) -> void:
	sprite.flip_h = !player.sprite.flip_h


func _on_bus_collected(data: Dictionary) -> void:
	if data.has("collected"):
		player.inventory.has_bus = data["collected"]
		_activate_bus()


func _activate_bus() -> void:
	sprite.visible = true
	collision.set_deferred("disabled", false)
	call_deferred("_update_player")
	set_process(true)


func _update_player() -> void:
	player.sprite.visible = false
	player.get_node("CollisionShape2D").set_deferred("disabled", true)
	player.trail.height = 15